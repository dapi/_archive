# -*- coding: utf-8 -*-
require 'spec_helper'


describe Notifier do

  #end

  #context 'The Notifications mailer' do
  
  # FIXTURES_PATH = File.dirname(__FILE__) + '/../../fixtures'
  #  CHARSET = 'utf-8'

  # fixtures :users

  # include MailerSpecHelper
  # include ActionMailer::Quoting

  # before do
  #   # You don't need these lines while you are using create_ instead of deliver_
  #   #ActionMailer::Base.delivery_method = :test
  #   #ActionMailer::Base.perform_deliveries = true
  #   #ActionMailer::Base.deliveries = []

  #   @expected = TMail::Mail.new
  #   @expected.set_content_type 'text', 'plain', { 'charset' => CHARSET }
  #   @expected.mime_version = '1.0'

  #   @user = Factory :user
  # end

  before {
    User.destroy_all
  }

  specify { ActionMailer::Base.deliveries.count.should == 0 }

  specify { User.count.should == 0 }

  context "send registration" do
    before {
      @user = Factory :user
      ActionMailer::Base.deliveries.clear
      Notifier.registration( @user ).deliver.should be_true
      #encoded.should == @expected.encoded
      @mail = ActionMailer::Base.deliveries.first
    }
    subject { @mail }
    
    specify { ActionMailer::Base.deliveries.count.should == 1 }

    it { should respond_to(:to) }
    it { should respond_to(:from) }
    
    specify { @mail.to.count.should == 1 }

    specify { @mail.to[0].should be_eql @user.email }
    specify { @mail.body.should include("Вы зарегистрированы") }
    specify { @mail.body.should include(@user.name) }

  end


end
