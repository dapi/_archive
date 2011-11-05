require 'test_helper'

class Admin::TagsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper 

  context "Admin tags controller" do

    context "editor logged in" do
      setup do
        login_as editor_user
      end

      context "get index" do
        setup do
          Factory.create(:tag)
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

      context "new tag" do
        setup do
          @tag = Factory.create(:tag)
        end

        context "on POST to :create" do
          setup do
            tags = Tag.find(:all)
            post :create, :tag => Hash[*@tag.attributes.select { |k,v| k.to_s != 'id' }.flatten]
            @created_tag = [tags - Tag.find(:all)].flatten.first
          end
          should_assign_to :tag
          should_respond_with :redirect
        end

        context "on GET to :edit" do
          setup do
            get :edit, :id => @tag.id
          end
          should_assign_to :tag
          should_respond_with :success
          should_render_template :edit
        end

        context "on GET to :show" do
          setup do
            get :show, :id => @tag.id
          end
          should_assign_to :tag
          should_respond_with :success
          should_render_template :show
        end

        context "on PUT to :update" do
          setup do
            put :update, :id => @tag.id, :tag => @tag.attributes
          end
          should_assign_to :tag
          should_respond_with :redirect
          should_redirect_to("show tag") { admin_tag_url(@tag) }
        end
        
        context "on DELETE to :destroy" do
          setup do
            @new_tag = Factory.create(:tag)
            delete :destroy, :id => @new_tag.id
          end
          should_assign_to :tag
          should_respond_with :redirect
          should_redirect_to("tags page") { admin_tags_url }
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