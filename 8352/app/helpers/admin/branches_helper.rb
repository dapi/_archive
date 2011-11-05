module Admin::BranchesHelper
  # Мемоизация сработала криво, так что, пришлось написать её вручную.
  # Всё сохраняется в @_evaluations чтобы вычисления производились один раз на запрос.
  # TODO Это место мне не очень нравится.
  {
    :open_icon => 'icon(:open, :id => "open_REPLACETHIS", :class => "_open", :rel => "REPLACETHIS", :style => "REPLACETHIS")',
    :close_icon => 'icon(:close, :id => "close_REPLACETHIS", :class => "_close", :rel => "REPLACETHIS", :style => "REPLACETHIS")',
    :empty_folder_icon => 'icon(:empty_folder, :class => "_empty_folder")',
    :move_icon => 'icon(:move, :class => "_move")',
    :clone_icon => 'icon(:clone, :class => "_clone")',
    :edit_branch_link => 'link_to(icon(:edit), edit_admin_branch_url(:id => "REPLACETHIS"), :class => "_edit", :style => "display: none;")',
    :delete_branch_link => 'link_to(icon(:delete), admin_branch_url(:id => "REPLACETHIS"), :confirm => "Вы уверены?", :method => :delete, :class => "_edit", :style => "display: none;" )',
    :left_branch_link => 'link_to icon(:arrow_up), move_left_admin_branch_url(:id => "REPLACETHIS"), :style => "display: none;", :class => "_edit _move_up"',
    :right_branch_link => 'link_to icon(:arrow_down), move_right_admin_branch_url(:id => "REPLACETHIS"), :style => "display: none;", :class => "_edit _move_down"',
    :group_name_link => 'link_to("REPLACETHIS", company_group_path(:id => "REPLACETHIS"))',
    :edit_group_link => 'link_to(icon(:edit), edit_admin_company_group_url(:id => "REPLACETHIS"), :class => "_edit", :style => "display: none;")',
    :detach_group_link => 'link_to(icon(:delete), detach_group_admin_branch_url(:id => "REPLACETHIS", :group_id => "REPLACETHIS"), :class => "_edit _delete", :style => "display: none;")',
    :up_group_link => 'link_to(icon(:arrow_up), branch_left_admin_branch_url(:id => "REPLACETHIS", :branch_id => "REPLACETHIS"), :class => "_edit _move_up", :style => "display: none;")',
    :down_group_link => 'link_to(icon(:arrow_down), branch_right_admin_branch_url(:id => "REPLACETHIS", :branch_id => "REPLACETHIS"), :class => "_edit _move_down", :style => "display: none;")'
    
  }.each do |m, value|
    define_method m do      
      @_evaluations ||= {}            
      # Где-то в недрах link_to происходит замена %s на нечто непонятное. Приходится использовать такой кривой хак.
      @_evaluations[m] = instance_eval(value).gsub('REPLACETHIS', '%s') unless @_evaluations.key?(m)
      @_evaluations[m]
    end
  end
end
