class Branch < ActiveRecord::Base
  acts_as_nested_set

  has_many :branch_company_groups, :order => "position ASC"  
  has_many :groups, :through => :branch_company_groups, :source => :company_group

  named_scope :with_groups, { :include => :groups }
  default_scope :order => "lft"
    
  def move_to_left_or_right(target)
    target = target.is_a?(Fixnum) ? self.class.find(target) : target
    if left > target.right
      move_to_left_of(target)
    else
      move_to_right_of(target)
    end
  end    

  # TODO: А тут бы я сделал так: сначала выбрал бы все ID, а потом уже все объекты.
  # Т.е. descendants -> массив ID, Group.find_by_branch_id(массив ID).collect id, Company.find_by_group_id.
  # Получится три запроса вместо N.
  # Всё-таки, парное программирование и ревизионирование рулит.
  # Виктор.
  def companies
    c=[]
    gs=groups
    descendants.map { |d| 
      gs=gs+d.groups
    }
    gs.map { |g| 
      c=c+g.companies
    }
    c
  end

  def breadcrumb
    self.root? ? [self] : self.parent.breadcrumb + [self]
  end
end
