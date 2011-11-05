# -*- coding: utf-8 -*-
require 'singleton'
require 'active_support'

class PhoneParser
  include Singleton

  # Выделяет телефоны из строки. Возвращает массив хешей [{ :phone => "телефон", :is_fax => true/false}]
  # Работает так:
  #   - В строке ищуся все потенциальные телефоны. Правила поиска описаны ниже, в комментарии к PHONE_EXTRACT_REGEXP.
  #   - Каждый найденный телефон прогоняется через список исключений (EXTRACT_PHONE_CONDITIONS), и отметается если сработало
  #     хотя бы одно исключение.
  #   - Проверяется, нашли мы факс или простой телефон, см. комментарии к is_fax?
  def parse(line)  
    cutting_line = line.dup
    
    # Выделяем потенциальные телефоны из строки. Unicode::downcase нужен потому что модифаер /i
    # раби регеэкспа несовместим с юникодом.
    parsed = line.scan(PHONE_EXTRACT_REGEXP).map do |m|
      phone = m[0]      
      department = unless m[1].nil?
        m[1] = m[1].match(DEPARTMENT_REGEXP)
        $1
      end
      is_phone = EXTRACTED_PHONE_CONDITIONS.map { |c| c.call(phone.dup) }.any?
      if is_phone
        cutting_line, is_fax = is_fax?(cutting_line, phone)
        { :number => phone, :is_fax => is_fax, :department => department }
      end
    end
    parsed.compact
  end

  protected
  # Проверяет, факс это или нет.
  # Для этого, в строке до телефона ищется слово "факс".
  # Сюда можно добавить проверку расстояния между словом "факс" и, собственно, телефоном.
  def is_fax?(line, phone)
    phone_index = line.mb_chars.index(phone)
    fax_slice = line.mb_chars[0, phone_index].downcase
    line = line.mb_chars[phone_index..-1]
    is_fax = !(fax_slice =~ FAX_REGEXP).nil?    
    [line, is_fax]
  end

  # Регулярное выражение для выделения телефона. Означает следующее:
  #   - До телефона может быть всё что угодно или пробел.
  #   - Телефон начинается с цифры, +, (
  #   - Телефон оканчивается на цифру.
  #   - Телефон не может содержать буквы, но может - цифры, пробелы, скобки, тире.
  #   - Перед телефоном может идти факс.
  #   - Между факсом и телефоном не должно быть ворд-символов.
  #   - После телефона идёт нечто в скобках - описание.
  PHONE_EXTRACT_REGEXP = /([\d\(\+]{1}[\d\-\(\)\s]+\d{1})(\s+?\(([\w\s\d\.\,]+)\))?[\b|\w]*/ui

  # Регулярное выражение для вырезания описания.
  DEPARTMENT_REGEXP = /[\s\(]+(.*)\)/
  
  # Регулярное выражение для выделения факса.
  FAX_REGEXP = /(ф\.|факс|fax)/ui
  
  # Условия, по которым проверяется телефон после выделения.
  # Сюда будем добавлять условия, которые найдём.
  EXTRACTED_PHONE_CONDITIONS = [
    # Длина телефона - от 5 до 13 цифр без знаков ()-+
    lambda { |phone| (5..13).member? phone.gsub(/[\-\s\(\)\s+]/, '').length }    
  ]
end
