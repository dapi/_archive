Factory.define :company do |f|
  f.sequence(:name) {|n| "company_#{n}" }
  f.sequence(:full_name) {|n| "company_full_#{n}" }
end