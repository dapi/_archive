require 'test_helper'

class Admin::CompaniesControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper 

  context "Admin companies controller" do

    context "editor logged in" do
      setup do
        login_as editor_user
      end

      context "get index" do
        setup do
          Factory.create(:company)
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

      context "new company" do
        setup do
          @company = Factory.create(:company)
        end

        context "on POST to :create" do
          setup do
            companies = Company.find(:all)
            post :create, :company => Hash[*@company.attributes.select { |k,v| k.to_s != 'id' }.flatten]
            @created_company = [companies - Company.find(:all)].flatten.first
          end
          should_assign_to :company
          should_respond_with :redirect
        end

        context "on GET to :edit" do
          setup do
            get :edit, :id => @company.id
          end
          should_assign_to :company
          should_respond_with :success
          should_render_template :edit
        end

        context "on PUT to :update" do
          setup do
            put :update, :id => @company.id, :company => @company.attributes
          end
          should_assign_to :company
          should_respond_with :redirect
          should_redirect_to("edit company") { edit_admin_company_url(@company) }
        end
        
        context "on DELETE to :destroy" do
          setup do
            @new_company = Factory.create(:company)
            delete :destroy, :id => @new_company.id
          end
          should_assign_to :company
          should_respond_with :redirect
          should_redirect_to("companies page") { admin_companies_url }
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