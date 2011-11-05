# -*- coding: utf-8 -*-
require 'spec_helper'

# Examples:
# http://kpumuk.info/ruby-on-rails/my-top-7-rspec-best-practices/


describe Debt do

  should_belong_to :creditor
  should_belong_to :debtor
  should_belong_to :user

  should_validate_presence_of :thing
  # should_validate_presence_of :till

  before {
    @debt = Debt.new
  }

  # before(:all) {
  #   DatabaseCleaner.start
  # }


  #after(:all) {
    #   DatabaseCleaner.clean
    #User.destroy_all
  #}

  
  subject { @debt }

  context "when all fields are empty" do
    it { should_not be_valid }
    it { @debt.is_credit?.should be_false }
    #specify { @debt.save.should be_false }
  end

  context "when till, thing are defined" do

    before {
      # User.destroy_all
      @debt = Factory(:user).debts.new(:thing=>'Some books',
                                       :till=>Date.today)
    }
    
    it { should be_invalid }
    it { should be_open }

    context "there is creditor_email, but no creditor in the db" do
      
      before {
        @debt = Factory(:user).debts.new(:thing => 'Some books',
                                         :till => Date.today,
                                         :creditor_attributes => {:email=>'somenew_creditor@mail.me'}
                                         )
      }
      
      specify { @debt.save.should be_true }

      it { should be_valid }
      it { should_not be_is_credit }


      context "saved" do
        before { @debt.save }

        it { should be_persisted }
        it { should be_accepted }
        it { should be_valid }
        it { @debt.errors.should be_empty }

        context "should automaticaly create contact for user" do 

          before { @contacts = @debt.user.contacts }
          subject { @contacts }

          it { should_not be_empty }
          specify { @contacts.first.partner.should be_eql @debt.partner }

        end

        context "Debt#contact" do
          before { @contact = @debt.contact }
          subject { @debt.contact }
          
          specify { @contact.should be_eql @debt.user.contact_for( @debt.partner ) }
          specify { @contact.user.should be_eql @debt.user }
        end

        context "owner should have debts for this contact" do 

          specify { @debt.user.contacts_debts(@debt.contact).first.should == @debt }
          
        end
          
        
        context "owner" do
          subject { @debt.user }
        
          it { should be_eql( @debt.debtor ) }
          it { should_not be_eql( @debt.partner ) }
        end

        context "creditor (partner)" do
          subject { @debt.creditor }

          it { @debt.creditor.email.should == "somenew_creditor@mail.me" }
          it { should be_virtual }
          it { should be_valid }
          it { should eql @debt.partner }
          it { should_not eql @debt.debtor }
          it { should be_persisted }
          it { User.exists?(:email=>@debt.creditor.email).should be_true }
        end

        
      end

      context "creditor's name" do
        before {
          @debt = Factory(:user).debts.new(:thing => 'Some books',
                                           :till => Date.today,
                                           :creditor_attributes => {
                                             :email=>'vasilec@mail.me',
                                             :name=>'Vasya'}
                                         )
        }

        it { should be_valid }
        specify { @debt.save.should be_true }
        
        context "saved" do
          before { @debt.save }
          
          specify { @debt.creditor.name.should be_eql 'Vasya' }
          specify { User.exists?(:email=>@debt.creditor.email).should be_true }
          specify { User.where(:email=>@debt.creditor.email).first.name.should be_eql 'Vasya' }


          # TODO Это должно быть письмо об авторегистрации и т.п.
          # context "confirmation emailed" do
          #   before {
          #     # ActionMailer::Base.deliveries.clear
          #     # @user.save
          #     @email  = ActionMailer::Base.deliveries.last
          #   }
        
          #   it { @debt.creditor.email.should be_eql @email.to[0] }
        
          #   it { @email.body.should include("подтверждает, что взял у Вас") }
          #   it { @email.body.should include(@debt.thing) }
          #   it { @email.body.should include(@debt.creditor.name) }
          #   it { @email.body.should include(@debt.creditor.authentication_token) }
          # end

        end
          
      end

    end

    context "creditor exists in the database" do

      before {
        # User.destroy_all
        @creditor = Factory :creditor
        @debt = Factory(:user).debts.new(:thing => 'Some books',
                                         :till => Date.today,
                                         :creditor_attributes => { :email => @creditor.email }
                                         )
      }

      # before(:all) {
      #   DatabaseCleaner.start
      # }

      after(:all) {
        User.destroy_all
      #   DatabaseCleaner.clean
      }
      
      specify { @debt.save.should be_true }
      
      it { should be_valid }
      it { should_not be_is_credit }

      context "saved" do
        before { @debt.save }
        
        it { should be_persisted }
        it { should be_valid }
        it { @debt.errors.should be_empty }


        context "close" do
          before { @debt.close }

          it { should be_closed }

          specify {
            @debt.update_attributes({:thing=> 'Some new thing in closes'}).should be_false
            @debt.should_not be_valid
            @debt.update_attributes({:till=> Date.today}).should be_false
            @debt.should_not be_valid
            @debt.save.should be_false
          }
        end

        context "owner" do
          subject { @debt.user }
        
          it { should be_eql( @debt.debtor ) }
          it { should_not be_eql( @debt.partner ) }
        end

        context "creditor (partner)" do
          subject { @debt.creditor }

          it { should be_eql @creditor }
          it { should be_normal }
          it { should be_valid }
          it { should eql @debt.partner }
          it { should_not eql @debt.debtor }
        end
        
      end

      context "creditor's name" do
        before {
          @creditor = Factory :creditor
          @debt = Factory(:user).debts.new(:thing => 'Some books',
                                           :till => Date.today,
                                           :creditor_attributes => {
                                             :email=>@creditor.email.upcase, # За одно проверим на caseinsens
                                             :name=>'Vasya'}
                                         )
        }

        it { should be_valid }
        specify { @debt.save.should be_true }
        
        context "saved" do
          before { @debt.save }

          it { @debt.creditor.should be_eql @creditor }
        end
          
      end
    end
    
  #   context "the debt is already exists" do

  #     before {
  #       @user = Factory(:user)
  #       @creditor = Factory :creditor

  #       @debt = @user.debts.new(:thing => 'Some books',
  #                               :till => Date.today,
  #                               :creditor_attributes => { :email=>@creditor.email }
  #                               )
  #     }
      
  #     specify { @debt.save.should be_true }
      
  #     it { should be_valid }
  #     it { should_not be_is_credit }

  #     context "duplicate debt" do

  #       before {
  #         @debt.save
  #         @debt2 = @user.debts.new(:thing => 'Some books',
  #                                  :till => Date.today,
  #                                  :creditor_attributes => { :email=>@creditor.email }
  #                                  )
  #       }
        
  #       subject { @debt2 }
        
  #       it { should_not be_valid }
  #       specify { @debt2.save.should_not be_true }
  #     end

  #   end
    
  end


    #Debt.notify_overdues
  # overdue_notify
  context "notify overdue" do
    
    before {
      # User.destroy_all
      @debt = Factory :debt
      ActionMailer::Base.deliveries.clear
      ActionMailer::Base.deliveries.count.should == 0
      @debt.notify_overdue

      # Письма отправляются в таком порядке
      @email_to_debtor  = ActionMailer::Base.deliveries.first
      @email_to_creditor  = ActionMailer::Base.deliveries.last
    }

    specify {
      # pending "А что это вообще такое"
      ActionMailer::Base.deliveries.count.should == 2
    }

    context "email to debtor" do
      subject { @email_to_debtor }

      specify { should respond_to :body }
      specify { @email_to_debtor.to[0].should be_eql @debt.debtor.email }
    
      specify { @email_to_debtor.body.should include "Напоминаем Вам что Вы должны вернуть" }
      specify { @email_to_debtor.body.should include @debt.thing }
      specify { @email_to_debtor.body.should include @debt.creditor.name }
      specify { @email_to_debtor.body.should include @debt.debtor.name }
    end
  end
end

# shared_examples_for "all editions" do
#   it "should behave like all editions" do
#   end
# end

# describe "SmallEdition" do
#   it_should_behave_like "all editions"

#   it "should also behave like a small edition" do
#   end
# end


  #  before :each
  #   before :all do
  #   @users = (1..5).collect { Factory(:user) }
  # end
  
  # after :all do
  #   @users.each { |user| user.destroy! }
  # end
  
  # pending "add some examples to (or delete) #{__FILE__}"
  # fixtures :all

#   describe DemoMan do
#   before(:all) do
#     @demo_man = DemoMan.new
#   end
 
#   subject { @demo_man }
 
#   it { should respond_to :name   }
#   it { should respond_to :gender }
#   it { should respond_to :age    }
# end

# require "cancan/matchers"
# # ...
# ability.should be_able_to(:destroy, Project.new(:user => user))
# ability.should_not be_able_to(:destroy, Project.new)
  # it "should be editable by admin" do
  #   article = Article.new(:name => "Foo")
  #   article.should be_editable_by(users(:admin))
  # end
  
  # it "should be editable by owner" do
  #   user = User.new
  #   article = Article.new(:name => "Foo", :user => user)
  #   article.should be_editable_by(user)
  # end
  
  # it "should not be editable by anyone" do
  #   article = Article.new(:name => "Foo")
  #   article.should_not be_editable_by(User.new)
  # end
  
