Factory.define :category do |f|
  f.sequence(:name) {|n| "category_#{n}" }
  f.sequence(:description) {|n| "category description #{n}" }
end