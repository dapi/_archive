class BranchCompanyGroup < ActiveRecord::Base
  belongs_to :branch
  belongs_to :company_group
  
  acts_as_list :scope => :branch_id
end
