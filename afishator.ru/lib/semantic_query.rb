# -*- coding: utf-8 -*-
require 'curb'
require 'json'
require 'semantic_response'

class SemanticQuery
  URL = 'g-calendar.appspot.com/application/parse'

  attr_reader :response, :error

  # message, timezone
  TIMEZONE='+3:00'

  def initialize(query)
    easy = Curl::Easy.new
    query_url = SemanticQuery::URL + '?message='+easy.escape(query)+'&tz='+SemanticQuery::TIMEZONE
    doc = Curl::Easy.http_get(query_url)

    if doc.response_code==200
      @response = SemanticResponse.new JSON.parse(doc.body_str)
      Rails.logger.info("Ответ на семантический запрос '#{query}': #{@response.to_s}")
    else
      @response = SemanticResponse.new :success=>false, :error_code=>doc.response_code, :error_message=>doc.body_str
      Rails.logger.error("Ответ на семантический запрос '#{query}': #{@response.error_code}")
    end
  end
end
