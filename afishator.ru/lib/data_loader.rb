# -*- coding: utf-8 -*-
class DataLoader
  # ATTRS = [:subject, :url, :image_url, :city, :address, :date, :time, :details, :category]

  def load_file(file)
    data={}
    d = JSON.parse( File.open(file).read )
    d.each_pair { |key, val|
      next if val.blank?
      val = val.strip.mb_chars.strip.to_s if val.is_a? String
      data[key.to_sym] = val
    }

    puts data[:subject]
    if data[:category]=='Кино'
      puts 'Кино, пропускаем'
      return
    end
    data[:time] = data[:date]+' '+data[:time]
    print data[:time], ' '

    plan = {:date=>data[:date], :time=>data[:time]}
    # event = Event.create data.slice(*DataLoader::ATTRS)
    data =  data.except(:date, :time, :dump, :dump_type, :index)

    key = data.slice(:subject, :category, :city, :place)

    event = Event.find_or_create_by(key)
    event.update_attributes(data)
    event.plans << Plan.new(plan)
    event.save!
  rescue Interrupt => e
    puts e
    raise e
  rescue Exception=>e
    puts e
  end

  def load_dir(dir='./json_data/')
    Dir.glob(dir + '*.json').sort.each do |file|
      print '.'
      load_file file
    end
  end
end
