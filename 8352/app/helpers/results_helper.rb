module ResultsHelper

  def head_compare(result)
    "<tr>
      <td>
        #{ check_box_tag 'result_records[' + result.id.to_s + ']head', '1', true,
            :id => dom_id(result),
            :onclick => 'set_mass_td_attr_class(this);' }
      </td>
      <td colspan='4'>
        <b>#{ result.storage.nil? ? 'Новая организация' : result.storage.name }</b>
      </td>
    </tr>"
  end

  def normalized_phone_number(phone_number)
  end

  def field_compare(result, field, field_name)

    normalized_phone_number = if field == :phones
                                begin
                                  normalize_phone(result[field])
                                rescue
                                  ''
                                end
                              else
                                nil
                              end

    if result.storage.nil? # if new record
         "<tr>
            <td></td>
            <td>
              #{ check_box_tag 'result_records[' + result.id.to_s + ']accept_' + field.to_s, '1', true,
                 :class => dom_id(result), :onclick => 'check_class(this);' }
            </td>
            <td>#{field_name}</td>
            <td></td>
            <td #{'style=\'background-color:red;\'' if normalized_phone_number && normalized_phone_number.blank? }>
              #{ result.column_for_attribute(field).type == :string ?
                   text_field_tag('result_records[' + result.id.to_s + ']' + field.to_s, normalized_phone_number || result[field], :size => 80) :
                   text_area_tag('result_records[' + result.id.to_s + ']other_info', normalized_phone_number || result[field], :size => (result[field].blank? ? '60x1' : '60x10')) }
              #{ '<span style=\'color:yellow;\'> ' + result[field] + '</span>' if normalized_phone_number && normalized_phone_number.blank? }
            </td>
          </tr>" if !result[field].blank?
    else
       # if exist record
        "<tr>
          <td></td>
          <td>
            #{check_box_tag 'result_records[' + result.id.to_s + ']accept_' + field.to_s, '1', true,
              :class => dom_id(result), :onclick => 'check_class(this);' }
          </td>
          <td>#{field_name}</td>
          <td>#{result.storage[field]}</td>
          <td>
            #{ result.column_for_attribute(field).type == :string ?
                 text_field_tag('result_records[' + result.id.to_s + ']address' + field.to_s, result[field], :size => 80) :
                 text_area_tag('result_records[' + result.id.to_s + ']other_info', result[field],  :size => (result[field].blank? ? '60x1' : '60x10')) }
          </td>
        </tr>" if result.storage[field] != result[field]
    end
  end

end
