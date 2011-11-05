# -*- coding: utf-8 -*-
class ActionController::Routing::RouteSet
  def add_configuration_file_with_e(path)
#    lib_path = File.dirname(__FILE__)
    clearance_routes = './config/clearance_routes.rb' ##File.join(lib_path, *%w[config clearance_routes.rb])
    
    if path =~ /clearance/
      
      # Определили через require в routes.rb
#      unless configuration_files.include?(clearance_routes)
#        add_configuration_file_without_e(clearance_routes)
#      end
    else 
      add_configuration_file_without_e(path)
    end

#    p "configure"

  end
  alias_method_chain :add_configuration_file, :e
end
 
#HOST = "localhost"
#DO_NOT_REPLY = "donotreply@example.com"
