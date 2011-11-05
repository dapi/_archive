class CategoriesCategory < ActiveRecord::Base
  
  belongs_to :child, :foreign_key=>'child_id', :class_name=>'Category', :counter_cache=>'parents_count'
  belongs_to :parent, :foreign_key=>'parent_id', :class_name=>'Category', :counter_cache=>'children_count'
  
  # before_save :bs
  # before_update :bu
  # before_create :bc
  # before_destroy :bd
  
  # before_validation :bv
  
  #  def bv
  #    p "before_validation"
  #  end

  
  #  def bs
  #    p "before_save"
  #  end

  #  def bu
  #    p "before_update"
  #  end

  #  def bc
  #    p "before_create"
  #  end

  #  def bd
  #    p "before_destroy"
  #  end

end
