# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{authlogic_generator}
  s.version = "0.5.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alessandro Dal Grande", "Marco Sanson"]
  s.date = %q{2009-08-31}
  s.description = %q{A gem to help you generate all the basic structure to use authlogic in your project.}
  s.email = %q{lab@develon.com}
  s.files = ["generators/authlogic_generator/authlogic_generator_generator.rb", "lib/authlogic_generator.rb", "generators/authlogic_generator/lib/insert_routes.rb", "generators/authlogic_generator/templates/controllers/activations_controller.rb", "generators/authlogic_generator/templates/controllers/password_resets_controller.rb", "generators/authlogic_generator/templates/controllers/user_sessions_controller.rb", "generators/authlogic_generator/templates/controllers/users_controller.rb", "generators/authlogic_generator/templates/lib/authlogic_user.rb", "generators/authlogic_generator/templates/migrate/create_users_and_sessions.rb", "generators/authlogic_generator/templates/models/notifier.rb", "generators/authlogic_generator/templates/models/user.rb", "generators/authlogic_generator/templates/models/user_session.rb", "generators/authlogic_generator/templates/views/activations/new.html.erb", "generators/authlogic_generator/templates/views/layouts/_usernav.html.erb", "generators/authlogic_generator/templates/views/notifier/activation_confirmation.text.html.erb", "generators/authlogic_generator/templates/views/notifier/activation_instructions.text.html.erb", "generators/authlogic_generator/templates/views/notifier/password_reset_instructions.text.html.erb", "generators/authlogic_generator/templates/views/notifier/activation_confirmation.text.plain.erb", "generators/authlogic_generator/templates/views/notifier/activation_instructions.text.plain.erb", "generators/authlogic_generator/templates/views/notifier/password_reset_instructions.text.plain.erb", "generators/authlogic_generator/templates/views/password_resets/activate.html.erb", "generators/authlogic_generator/templates/views/password_resets/index.html.erb", "generators/authlogic_generator/templates/views/password_resets/show.html.erb", "generators/authlogic_generator/templates/views/user_sessions/new.html.erb", "generators/authlogic_generator/templates/views/users/_form.html.erb", "generators/authlogic_generator/templates/views/users/edit.html.erb", "generators/authlogic_generator/templates/views/users/new.html.erb", "generators/authlogic_generator/templates/views/users/private.html.erb", "generators/authlogic_generator/templates/views/users/public.html.erb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/develon/authlogic_generator}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{authlogic_generator}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{This generator for authlogic creates models, controllers and view for authentication, user activation and password resetting.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<authlogic>, [">= 2.1.1"])
    else
      s.add_dependency(%q<authlogic>, [">= 2.1.1"])
    end
  else
    s.add_dependency(%q<authlogic>, [">= 2.1.1"])
  end
end
