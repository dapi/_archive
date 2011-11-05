class User < ActiveRecord::Base
  acts_as_authentic

  <% unless options[:skip_password_reset] %>
    def deliver_password_reset_instructions!
      reset_perishable_token!
      Notifier.deliver_password_reset_instructions(self)
    end
  <% end %>
  
  <% unless options[:skip_activation] %>
    def deliver_activation_instructions!
      reset_perishable_token!
      Notifier.deliver_activation_instructions(self)
    end
    
    def activate!
      self.active = true
      self.save
    end
  <% end %>

  def deliver_activation_confirmation!
    reset_perishable_token!
    Notifier.deliver_activation_confirmation(self)
  end

  
end
