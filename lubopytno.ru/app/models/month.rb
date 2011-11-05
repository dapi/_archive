# -*- coding: utf-8 -*-
class Month
  
  attr_reader :date
#  has_many :days
  
#  validates_presence_of :date
#  validates_uniqueness_of :date
  def initialize(date)
    @date = date.kind_of?(Date) ? date : parse_date(date)
  end

  def self.find(dm)
#    self.month=month
    #    all.detect { |l| l.to_param == param } || raise(ActiveRecord::RecordNotFound)
    # 
    self.new(dm) || raise(ActiveRecord::RecordNotFound)
  end
  
  # def self.all
  #   date=Date::new(2009,01,01)
  #   9.times.map { 
  #     m=Month::new(date)
  #     date=date.next_month
  #     m
  #   }
  # end
  
  
  def self.list_from_to(from,to)
    from = self.find(from)
    list = [from]
    current = from
    while current!=to
      current=current.next
      list << current
    end
    return list
  end
  
  def == (a)
    p "compare #{self.to_s} == #{a.to_s}"
    self.to_s==a.to_s
  end
  
  # Сделаем div для JS lenta
  # "<div id = "2009month_lenta09" class="month_lenta">
  #                  <div class = "day" ></div>
  #                  <div class = "day" ></div>
  #                            ...
  #               </div>"
  # def div_render
  #   render_to_string :partial=>'lenta/month', :locals=>{ :month=>self }
  # end
  
  def to_s
    mon=@date.mon.to_i
    mon="0#{mon}" if mon<10
    "#{@date.year}-#{mon}"
  end

  def month_name
    #I18n::translate 
    Date::MONTHNAMES[@date.mon]
  end
  
  def en_month_name
    Date::MONTHNAMES[@date.mon]
  end
  
  def next
    mon = self.month + 1
    year = self.year
    if mon>12
      mon=1
      year=year+1
    end

    Month.find("#{year}-#{mon}")
  end
  
  def days
    date = @date
    list = []
    while date<=@date.end_of_month
      list << Day.find_or_create_by_date(date)
      date=date+1
    end
    list
  end
  
  def month
    @date.month
  end
  
  def year
    @date.year
  end
  
  def link
    link="#{@date.year}-#{@date.mon}"
    "/months/#{link}.json"
  end
  
  def days_in_month
    @date.end_of_month.day
#    (@date.next_month-1.day).day
  end

  def parse_date(dm)
    # TODO Разбор даты dm, 2009-01 или 2009-01-01
    #    return Date::parse(dm)
    y,m,d=dm.split('-')
    d=1 unless d
    return Date::new(y.to_i,m.to_i,d.to_i)
  end

  private :parse_date

end
