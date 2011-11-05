# -*- coding: utf-8 -*-
require 'test_helper'
#require 'phone_parser'

class PhoneParserTest < Test::Unit::TestCase
  def test_success_parsing
    SUCCESS_PHONES.each do |line, result|
      parsed = PhoneParser.instance.parse(line)
      result = [result] if result.is_a? String
      phones = parsed.map { |data| data[:number] }
      assert_equal(phones, result, "Line: #{line} | Result was: #{phones.inspect} | Result should be: #{result.inspect}")
    end
  end

  def test_failuring_parsing
    FAILING_PHONES.each do |line|
      parsed = PhoneParser.instance.parse(line)
      assert(parsed.empty?)
    end
  end

  def test_fax_parsing
    FAX_PHONES.each do |line, fax|
      parsed = PhoneParser.instance.parse(line)
      assert_equal(parsed[0][:is_fax], fax, "Line: #{line}")
    end
  end

  def test_department_parsing
    DEPARTMENT_PHONES.each do |line, result|
      parsed = PhoneParser.instance.parse(line)
      assert_equal(parsed, result, "Line: #{line}")
    end
  end

protected
  SUCCESS_PHONES = {
    '123-45-67' => '123-45-67', 
    '+79046304552' => '+79046304552', 
    '+7(904)630-45-52' => '+7(904)630-45-52', 
    '+7 (904) 630-45-52' => '+7 (904) 630-45-52', 
    '8-904-12-33-444' => '8-904-12-33-444',
    '(904) 630-45-52' => '(904) 630-45-52',
    'text before (904) 630-45-52' => '(904) 630-45-52',
    '(904) 630-45-52 text after' => '(904) 630-45-52',
    'text before (904) 630-45-52 text after' => '(904) 630-45-52',
    'text before7904-630-45-52' => '7904-630-45-52',
    '7904-630-45-52text after' => '7904-630-45-52',
    'text before7904-630-45-52text after' => '7904-630-45-52',
    'text before7904-630-45-52text after904-33-22' => ['7904-630-45-52', '904-33-22'],
  }
  
  FAILING_PHONES = [
    '2004', '5-0', '18-19', '120', '450'
  ]

  FAX_PHONES = {
    '+7904630-45-52' => false,
    'факс: +7904630-45-52' => true,
    'Факс: +7904630-45-52' => true,
    'тел./факс: +79046304552' => true,
    '+79046666 факс: 333-22-22' => false
  }
  
  DEPARTMENT_PHONES = {
    'Phones are: (904)11-22-33 (dumb ass), +7 (905) 123456 (department of хеад cutting, room 55)' => [
      {:number => '(904)11-22-33', :is_fax => false, :department => "dumb ass" },
      {:number => '+7 (905) 123456', :is_fax => false, :department => "department of хеад cutting, room 55"}
    ],
    "Телефоны: (8352) 61-21-25, 61-21-00, 63-80-47, 28-71-91
Факс: 28-74-55" => [
                    {:department=>nil, :number=>"(8352) 61-21-25", :is_fax=>false},
                    {:department=>nil, :number=>"61-21-00", :is_fax=>false},
                    {:department=>nil, :number=>"63-80-47", :is_fax=>false},
                    {:department=>nil, :number=>"28-71-91", :is_fax=>false},
                    {:department=>nil, :number=>"28-74-55", :is_fax=>true}
                   ]
  }
end
