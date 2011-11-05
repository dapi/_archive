# -*- coding: utf-8 -*-
class EventsController < ApplicationController

  def index
    query = params[:query] # ||= 'завтра вечером'

    @response = SemanticQuery.new(query).response if query

    per_page = 15

    @search = Event.search do

      with(:date).greater_than(Date.today)

      if query.blank?
        order_by :date, :asc
        order_by :time, :asc
      else
        keywords query do
          highlight *Event::SEARCHABLE_FIELDS
        end
      end

      # paginate :per_page => per_page
    end


  # @conditions={}
  # if message = @params['message'] and @result = GCal.query(message) and
  #     @result['success'] and @result['type']=='event'
  #   event = @result['event']
  #   title = event['title']
  #   date = Date.parse(event['startDate'])
  #   time = Time.parse(event['startDate']) unless event['allDay']
  #   if title.blank?
  #     @conditions[:date] = date if date
  #     @conditions[:time] = time if time
  #     @conditions[:city] = event['city'] if event['city']
  #     @events = Event.paginate({conditions: @conditions, per_page: per_page, sort: ['_id', :asc]})
  #   else
  #     @search = Event.search do
  #       keywords event['title'] do
  #         highlight *Event::SEARCHABLE_FIELDS
  #       end
  #       with :date, date if date
  #       with :time, time if time
  #       with :city, event['city'] if event['city']
  #       # order_by :average_rating, :desc
  #       paginate :per_page => per_page
  #     end
  #   end
  # elsif not message.blank?
  #   @search = Event.search do
  #     keywords message do
  #       highlight *Event::SEARCHABLE_FIELDS
  #     end
  #     paginate :per_page => per_page
  #   end
  # else
  #   @events = Event.paginate({conditions: @conditions, per_page: per_page, sort: ['_id', :asc]})
  # end
  end
end
