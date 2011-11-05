# -*- coding: utf-8 -*-
require 'spec_helper'

# Examples:
# http://kpumuk.info/ruby-on-rails/my-top-7-rspec-best-practices/


describe Credit do

  should_belong_to :creditor
  should_belong_to :debtor
  should_belong_to :user

  should_validate_presence_of :thing
  # should_validate_presence_of :till

  before {
    @credit = Credit.new
  }
  
  subject { @credit }

  context "when all fields are empty" do
    it { should_not be_valid }
    it { @credit.is_credit?.should be_true }
  end

  context "when till, thing are defined" do

    before {
      @credit = Factory(:user).credits.new(:thing=>'Some books',
                                           :till=>Date.today)
    }
    
    it { should be_invalid }
    it { should be_open }

    context "there is debtor_email, but no debtor in the db" do
      
      before {
        @credit = Factory(:user).credits.new( :thing => 'Some books',
                                              :till => Date.today,
                                              :debtor_attributes => {:email=>'somenew_debtor@mail.me'}
                                              )
      }
      
      specify { @credit.save.should be_true }
      
      it { should be_valid }
      it { should be_is_credit }
      
      
      context "saved" do
        before { @credit.save }
        
        it { should be_persisted }
        it { should be_wait }
        it { should be_valid }
        it { @credit.errors.should be_empty }
        
        context "owner" do
          subject { @credit.user }
        
          it { should be_eql( @credit.creditor ) }
          it { should_not be_eql( @credit.partner ) }
        end

        context "debtor (partner)" do
          subject { @credit.debtor }

          it { @credit.debtor.email.should == "somenew_debtor@mail.me"  }
          it { should be_virtual }
          it { should be_valid }
          it { should eql @credit.partner }
          it { should_not eql @credit.creditor }
          it { should be_persisted }
          it { User.exists?(:email=>@credit.debtor.email).should be_true }
        end

        
      end

      context "debtor's name" do
        before {
          @credit = Factory(:user).credits.new(:thing => 'Some books',
                                           :till => Date.today,
                                           :debtor_attributes => {
                                             :email=>'vasilec@mail.me',
                                             :name=>'Vasya'}
                                         )
        }

        it { should be_valid }
        specify { @credit.save.should be_true }
        
        context "saved" do
          before { @credit.save }
          
          specify { @credit.debtor.name.should be_eql 'Vasya' }
          specify { User.exists?(:email=>@credit.debtor.email).should be_true }
          specify { User.where(:email=>@credit.debtor.email).first.name.should == 'Vasya' }


          context "confirmation emailed" do
            before {
              @email  = ActionMailer::Base.deliveries.last
            }
        
            it { @credit.debtor.email.should be_eql @email.to[0] }
        
            it { @email.body.should include("просит подтвердить, что вы взяли у него") }
            it { @email.body.should include(@credit.thing) }
            it { @email.body.should include(@credit.user.name) }
            it { @email.body.should include(@credit.debtor.authentication_token) }
          end
          
        end
        
      end
      
    end
    
    context "debtor exists in the database" do

      before {
        @debtor = Factory :debtor
        @credit = Factory(:user).credits.new(:thing => 'Some books',
                                           :till => Date.today,
                                           :debtor_attributes => { :email => @debtor.email }
                                           )
      }
      
      specify { @credit.save.should be_true }
      specify { @debtor.should be_normal }
      specify { @credit.debtor.should be_normal }
      
      it { should be_valid }
      it { should be_is_credit }

      context "saved" do
        before { @credit.save }
        
        specify { @credit.debtor.should be_normal }
        
        it { should be_persisted }
        it { should be_valid }
        it { @credit.errors.should be_empty }

        context "accept_state" do
          
          it { should be_wait }

          it { should_not be_changed }
          it { should_not be_new_record }
          it { should be_wait }

          context "accept" do

            before { @credit.accept }

            it { should be_accepted }
            it { should_not be_wait }

            specify {
              @credit.decline
              @credit.should_not be_declined
            }

          end

        end
        
        context "owner" do
          subject { @credit.user }
        
          it { should be_eql( @credit.creditor ) }
          it { should_not be_eql( @credit.partner ) }
        end

        context "debtor (partner)" do
          subject { @credit.debtor }

          it { should be_eql @debtor }
          it { should be_normal }
          it { should be_valid }
          it { should eql @credit.partner }
          it { should_not eql @credit.creditor }
          it { should be_persisted }
        end
        
      end

      context "debtor's name" do
        before {
          @debtor = Factory :debtor
          @credit = Factory(:user).credits.new(:thing => 'Some books',
                                           :till => Date.today,
                                           :debtor_attributes => {
                                             :email=>@debtor.email.upcase, # За одно проверим на caseinsens
                                             :name=>'Vasya'}
                                         )
        }

        it { should be_valid }
        specify { @credit.save.should be_true }
        
        context "saved" do
          before { @credit.save }

          it { @credit.debtor.should be_eql @debtor }
        end
        
      end
    end
  end
end  
