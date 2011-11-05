# -*- coding: utf-8 -*-
require 'data_loader'

desc "json_data"
namespace :data do

  desc "Импортировать собранные json-файлы в базу"
  task :load =>:environment do
    puts "Load json_data"
    Event.delete_all
    DataLoader.new.load_dir
    Sunspot.commit
  end

  desc "Sunspot reindex"
  task :reindex=>:environment do
    puts "Reindex sunspot"
    Sunspot.index(Event.all)
    Sunspot.commit
  end
end
