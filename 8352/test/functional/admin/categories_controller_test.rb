require 'test_helper'

class Admin::CategoriesControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper 

  context "Admin categories controller" do

    context "editor logged in" do
      setup do
        login_as editor_user
      end

      context "get index" do
        setup do
          Factory.create(:category)
          get :index
        end
        should_respond_with :success
        should_render_template :index
      end

      context "get new" do
        setup do
          get :new
        end
        should_respond_with :success
        should_render_template :new
      end

      context "new category" do
        setup do
          @category = Factory.create(:category)
        end

        context "on POST to :create" do
          setup do
            categories = Category.find(:all)
            post :create, :category => Hash[*@category.attributes.select { |k,v| k.to_s != 'id' }.flatten]
            @created_category = [categories - Category.find(:all)].flatten.first
          end
          should_assign_to :category
          should_respond_with :redirect
        end

        context "on GET to :edit" do
          setup do
            get :edit, :id => @category.id
          end
          should_assign_to :category
          should_respond_with :success
          should_render_template :edit
        end

        context "on GET to :show" do
          setup do
            get :show, :id => @category.id
          end
          should_assign_to :category
          should_respond_with :success
          should_render_template :show
        end

        context "on PUT to :update" do
          setup do
            put :update, :id => @category.id, :category => @category.attributes
          end
          should_assign_to :category
          should_respond_with :redirect
          should_redirect_to("show category") { admin_category_url(@category) }
        end
        
        context "on DELETE to :destroy" do
          setup do
            @new_category = Factory.create(:category)
            delete :destroy, :id => @new_category.id
          end
          should_assign_to :category
          should_respond_with :redirect
          should_redirect_to("categories page") { admin_categories_url }
        end
        
      end
    end

    context "public user" do
      setup do
        logout
      end
      
      context "get index" do
        setup do
          get :index
        end
        should_respond_with :redirect
        should_redirect_to("login page") { new_session_url }
      end
    end
  end
end