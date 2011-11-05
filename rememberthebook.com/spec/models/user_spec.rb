# -*- coding: utf-8 -*-
require 'spec_helper'

# TODO разделить по shared группам http://rspec.info/documentation/

describe User do 


  pending " it { should normalize_attribute(:email) } "
  it { should normalize_attribute(:name).from('  Vasya  ').to('Vasya') }
  it { should normalize_attribute(:open_id_uid).from('  http://dapi.aaa/  ').to('http://dapi.aaa/') }


  before { @user = User.new }
  subject { @user }

  should_have_many :credits
  should_have_many :debts

  # should_validate_presence_of :email
  
  # Что-то на ней срабатывает
  #should_validate_uniqueness_of :email
  
  #should_not allow_values_for :email, "blah", "b lah" 
  #should allow_values_for :email, "a@b.com", "asdf@asdf.com" 
  # it { should have_many :debts }
  #should validate_presence_of :email
  #should_ensure_length_in_range :email, 6..100
  #should_ensure_value_in_range :age, 1..100
  #should_not_allow_mass_assignment_of :password, :name, :email
  

  pending "should presense email, name, password or authentication"
  it { should be_valid }
  
  context "when email presented" do

    before { @user = User.new( :email=>'VASYA@MAIL.RU' ) }
    # subject { @user }

    context "and password is empty" do
      it { should be_valid }
      specify { @user.save.should be_true }
      specify { @user.encrypted_password.should be_empty }
      
      context "saved" do
        before {
          ActionMailer::Base.deliveries.clear
          @user.save
        }
        it { should be_nopass }
        specify { @user.authentication_token.should_not be_empty }
        specify { @user.encrypted_password.should be_empty }
        specify { @user.email.should == @user.email.downcase }

        context "registration emailed" do
          before { @email  = ActionMailer::Base.deliveries.last }
          
          it { @user.email.should be_eql @email.to[0] }
          
          it { @email.body.should be_include("зарегистрированы") }
          # it { @email.body.should be_include("автоматически сгенерированным паролем") }
          
        end

        context "clear the virtual when update password" do
          before { @user.update_attributes({:password=>'secret',:password_confirmation=>'secret'}) }
          specify { @user.should be_normal }
      end


      end

      # context "and generate password" do
      #   before { @password = @user.generate_password! }

      #   specify { @password.should_not be_empty }
      #   specify { @user.encrypted_password.should_not be_empty }
      # end
      
    end

    context "and password exists" do
      before { @user.password = @user.password_confirmation = 'secret' }
      
      it { should be_valid }
      specify { @user.save.should be_true }
      specify { @user.should be_normal }
      specify { @user.should be_valid_password('secret') }
      specify { @user.should_not be_valid_password('wrong') }


      context "registration emailed" do
        before {
          ActionMailer::Base.deliveries.clear
          @user.save
          @email  = ActionMailer::Base.deliveries.last
        }
        
        it { @user.email.should be_eql @email.to[0] }
        
        it { @email.body.should include("зарегистрированы") }
        it { @email.body.should_not include("автоматически сгенерированным паролем") }
      end

      # context "but generate new password" do
      #   before { @password = @user.generate_password! }

      #   specify { @password.should_not be_empty }
      #   specify { @user.encrypted_password.should_not be_empty }
      #   specify { @user.is_virtual.should be_true }

    #  end




    end

  end

  context "factories" do
    it "should be valid" do
      Factory(:user).should be_valid
    end
  end

end
