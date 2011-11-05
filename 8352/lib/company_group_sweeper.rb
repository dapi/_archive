class CompanyGroupSweeper < ActionController::Caching::Sweeper
  observe CompanyGroup
  observe BranchCompanyGroup
  
  def after_save(object)
    company_group_id = object.is_a?(CompanyGroup) ? object.id : object.company_group.id
    expire_fragment("admin_source_group:#{company_group_id}")
  end
end