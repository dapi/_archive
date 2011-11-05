formats = {
  :full => '%B %d, %Y at %I:%M %p',
  :md => '%m/%d',
  :mdy => '%m/%d/%y',
  :time => '%I:%M %p',
  :friendly => lambda { |time|
     if time.year == Time.now.year
       time.strftime "%b #{time.day.ordinalize}"
     else
       time.strftime "%b #{time.day.ordinalize}, %Y"
     end
   }
}

Time::DATE_FORMATS.merge! formats

Date::DATE_FORMATS.merge! formats

# Time::DATE_FORMATS[:due_time] = "due on %B %d at %I:%M %p"

