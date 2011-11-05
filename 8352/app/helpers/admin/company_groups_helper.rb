module Admin::CompanyGroupsHelper
  def company_group_select
    select_tag :group_id, options_for_select(CompanyGroup.ordered.collect { |g| [g.name, g.id] })
  end
end
