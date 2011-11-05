
if defined?(Vlad)
  begin
#   require 'vlad'
    Vlad.load( :web => 'nginx',
               :app=>'passenger', #              :app=>'passenger', 
               :scm => "git",
               :config => 'config/vlad_deploy.rb')
  rescue LoadError => e
    puts "Unable to load Vlad #{e}."
  end
  
end
