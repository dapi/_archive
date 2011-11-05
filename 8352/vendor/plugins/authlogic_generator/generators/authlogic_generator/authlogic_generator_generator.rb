require File.expand_path(File.dirname(__FILE__) + "/lib/insert_routes.rb")

class AuthlogicGeneratorGenerator < Rails::Generator::Base
  default_options :skip_activation => false,
                  :skip_password_reset => false,
                  :skip_migration => false,
                  :skip_routes => false
  
  def manifest
    recorded_session = record do |m|
      
      m.directory 'app/views/layouts'
      m.directory 'app/views/notifier'
      m.directory 'app/views/user_sessions'
      m.directory 'app/views/users'
      
      m.file 'controllers/user_sessions_controller.rb', 'app/controllers/user_sessions_controller.rb'
      m.template 'controllers/users_controller.rb', 'app/controllers/users_controller.rb'
      m.template 'models/notifier.rb', 'app/models/notifier.rb'
      m.template 'models/user.rb', 'app/models/user.rb'
      m.file 'models/user_session.rb', 'app/models/user_session.rb'
      m.template 'views/layouts/_usernav.html.erb', 'app/views/layouts/_usernav.html.erb'
      m.file 'views/notifier/activation_confirmation.text.html.erb', 'app/views/notifier/activation_confirmation.text.html.erb'
      m.file 'views/notifier/activation_confirmation.text.plain.erb', 'app/views/notifier/activation_confirmation.text.plain.erb'
      m.file 'views/user_sessions/new.html.erb', 'app/views/user_sessions/new.html.erb'
      m.file 'views/users/_form.html.erb', 'app/views/users/_form.html.erb'
      m.file 'views/users/edit.html.erb', 'app/views/users/edit.html.erb'
      m.file 'views/users/new.html.erb', 'app/views/users/new.html.erb'
      m.file 'views/users/private.html.erb', 'app/views/users/private.html.erb'
      m.file 'views/users/public.html.erb', 'app/views/users/public.html.erb'
      m.file 'lib/authlogic_user.rb', 'lib/authlogic_user.rb'
      
      unless options[:skip_password_reset]
        m.directory 'app/views/password_resets'
        m.template 'controllers/password_resets_controller.rb', 'app/controllers/password_resets_controller.rb'
        m.file 'views/notifier/password_reset_instructions.text.html.erb', 'app/views/notifier/password_reset_instructions.text.html.erb'
        m.file 'views/notifier/password_reset_instructions.text.plain.erb', 'app/views/notifier/password_reset_instructions.text.plain.erb'
        m.file 'views/password_resets/index.html.erb', 'app/views/password_resets/index.html.erb'
        m.file 'views/password_resets/show.html.erb', 'app/views/password_resets/show.html.erb'
      end
      
      unless options[:skip_activation]
        m.directory 'app/views/activations'
        m.file 'controllers/activations_controller.rb', 'app/controllers/activations_controller.rb'
        m.file 'views/activations/new.html.erb', 'app/views/activations/new.html.erb'
        m.file 'views/notifier/activation_instructions.text.html.erb', 'app/views/notifier/activation_instructions.text.html.erb'
        m.file 'views/notifier/activation_instructions.text.plain.erb', 'app/views/notifier/activation_instructions.text.plain.erb'
        m.file 'views/password_resets/activate.html.erb', 'app/views/password_resets/activate.html.erb' unless options[:skip_password_reset]
      end
      
      unless options[:skip_routes]
        m.route_resources :users
        m.route_resources :password_resets unless options[:skip_password_reset]
        m.route_resource :user_session
        m.route_name('login', '/login', { :controller => 'user_sessions', :action => 'new' })
        m.route_name('logout', '/logout', { :controller => 'user_sessions', :action => 'destroy' })
        m.route_name('register', '/register/:activation_code', { :controller => 'activations', :action => 'new' }) unless options[:skip_activation]
      end
      
      unless options[:skip_migration]
        m.migration_template "migrate/create_users_and_sessions.rb", "db/migrate", :migration_file_name => "create_users_and_sessions" unless options[:skip_migration]
      end
      
    end
    
    puts "\n1) Please add these lines to your ApplicationController\n\ninclude AuthlogicUser\nfilter_parameter_logging :password, :password_confirmation\nhelper_method :current_user_session, :current_user\n\n"
    puts "2) Please add these lines to your environment and launch rake gems:install\n\nconfig.gem 'binarylogic-authlogic', :lib => 'authlogic', :source => 'http://gems.github.com'\n\n"
    puts "3) Please remember to launch rake db:migrate\n\n" unless options[:skip_migration]
    
    recorded_session
  end
  
  protected
  def add_options!(opt)
      opt.separator ''
      opt.separator 'Options:'
      opt.on("--skip-activation", "Don't generate activation views and controller.") { |v| options[:skip_activation] = true }
      opt.on("--skip-password-reset", "Don't generate controller and views for password resetting.") { |v| options[:skip_password_reset] = true }
      opt.on("--skip-migration", "Don't generate a migration file for this model.") { |v| options[:skip_migration] = true }
      opt.on("--skip-routes", "Don't add lines to the route file.") { |v| options[:skip_routes] = true }
  end
end