require 'spec_helper'
require 'devise/test_helpers'

describe "devise/sessions/new.html.erb" do

  include Devise::TestHelpers
  
  def with_scope(locator)
    locator ? within(locator) { yield } : yield
  end
  
  let(:user) do
    stub_model(User).as_new_record
  end

  before do
    assign(:user, user)
    # Devise provides resource and resource_name helpers and
    # mappings so stub them here.
    @view.stub(:resource).and_return(@user)
    @view.stub(:resource_name).and_return('user')
    @view.stub(:devise_mapping).and_return(Devise.mappings[:user])
  end

  # it "renders a form to sign the user in" do
  #   render

    # text = 'form'
    # if response.respond_to? :should
    #   response.should have_content(text)
    # else
    #   assert response.has_content?(text)
    # end
      
    # rendered.should have_xpath(".//form", :text => "Home")
      # pp rendered.class
      
    #response.should have_xpath(".//form")
#    response.should have_css("form")
    
    # rendered.should have_selector("form",
    #                               :method => "post",
    #                               :action => user_session_path
    #                               ) do |form|
    #   form.should have_selector("input", :type => "submit")
    # end
#  end
  
end

    # describe "A Project" do
    #   describe "associations" do

    #     subject { Factory(:project) }

    #     it { should have_many(:tasks) }
    #     it { should belong_to(:project_status) }
    #   end

    #   describe "validations" do
    #     subject { Factory(:project) }

    #     it { should validate_presence_of(:name) }

    #     it { should validate_uniqueness_of(:name).case_insensitive }

    #     it { should allow_mass_assignment_of(:name) }
    #   end

  
