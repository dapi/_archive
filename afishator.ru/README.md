= Афишатор

Соединяем семантический анализ запроса с базой событий

= Структура поискового запроса

* datetime (timestamp, duration или interval)
  1. timestamp. дата и время не локализованные в формате YYYY-MM-DDThh:mm
     * Если времени нет, то указывается только дата (без T...). Это означает "весь день"
     * Если даты нет, то только время: T[hh]:[mm]
  2. duration (сегодня, завтра, через 3 дня/неделю/месяц, через 2 часа) в формате http://en.wikipedia.org/wiki/ISO_8601#Durations
     Например: P3Y6M4DT12H30M5S
     * Сегодня через 2 часа = P0DT2H или PT2H
     * Завтра в 14:00 = P1DT14:00
  3. interval (с 18 до 19-ти и т.п.) в формате http://en.wikipedia.org/wiki/ISO_8601#Time_intervals
  http://support.sas.com/documentation/cdl/en/lrdict/64316/HTML/default/viewer.htm#a003169814.htm
* subject
  название
* category
  категория (тип мероприятия: кино, театр, вечеринка)
* city
  город
* address
  местоположение (адрес - улица и т.п.)
* place
  название места/заведения (кинотеатр "Сеспель")

Если значение параметра не известо (nil или не установлено), то оно воспринимается как любое

= Примеры запросов:

== Завтра в 8
   type="event",
   success=true,
   event={"title"=>"", "startDate"=>"2011-05-25T08:00", "endDate"=>"2011-05-25T09:00", "description"=>"", "repeat"=>"Once", "allDay"=>false}

== сегодня в 16 в чебоксарах
   type="event", success=true,
   event={"title"=>"", "startDate"=>"2011-05-24T16:00", "endDate"=>"2011-05-24T17:00", "description"=>"", "location"=>"чебоксары", "city"=>"чебоксары", "repeat"=>"Once", "allDay"=>false}

== сегодня с 16 до 19


= Start

> rake sunspot:solr:start

= Maintance

> rake data:load  # Загружыет json-данные из json_data
> rake data:reindex
> rake sunspot:reindex
> rake db:mongoid:create_indexes

= Sunspot

wildcards - https://github.com/outoftime/sunspot/wiki/Wildcard-searching-with-ngrams
