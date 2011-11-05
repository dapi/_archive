Rails::Generator::Commands::Create.class_eval do
  def route_resources(*resources)
    write_route 'resources', resources
  end
  
  def route_resource(*resources)
    write_route 'resource', resources
  end
  
  def route_name(name, path, options={})
    write_route nil, nil, name, path, options
  end
end

Rails::Generator::Commands::Destroy.class_eval do
  def route_resource(*resources)
    remove_route look_for, 'resource', resource_list
  end
  
  def route_resource(*resources)
    remove_route look_for, 'resource', resource_list
  end
  
  def route_name(name, path, options = {})
    remove_route look_for, nil, nil, name, path, options
  end
end

def write_route(type=nil, resources=nil, name=nil, path=nil, options={})
  resource_list = resources.map { |r| r.to_sym.inspect }.join(', ') if name.nil?
  sentinel = 'ActionController::Routing::Routes.draw do |map|'
  logger.route name.nil? ? "map.#{type} #{resource_list}" : "map.#{name} '#{path}', :controller => '#{options[:controller]}', :action => '#{options[:action]}'"
  unless options[:pretend]
      gsub_file 'config/routes.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
        name.nil? ? "#{match}\n  map.#{type} #{resource_list}" : "#{match}\n  map.#{name} '#{path}', :controller => '#{options[:controller]}', :action => '#{options[:action]}'"
      end
  end
end

def remove_route(look_for, type=nil, resource_list=nil, name=nil, path=nil, options={})
  resource_list = resources.map { |r| r.to_sym.inspect }.join(', ') if name.nil?
  look_for = name.nil? ? "\n map.resources #{resource_list}\n" : "\n map.#{name} '#{path}', :controller => '#{options[:controller]}', :action => '#{options[:action]}'"
  logger.route name.nil? ? "map.#{type} #{resource_list}" : "map.#{name} '#{path}', :controller => '#{options[:controller]}', :action => '#{options[:action]}'"
  gsub_file 'config/routes.rb', /(#{look_for})/mi, ''
end