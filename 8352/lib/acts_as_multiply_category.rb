# -*- coding: utf-8 -*-

module ActsAsMultiplyCategory
  
  def self.included(base)
    base.extend(ClassMethods)
  end

  
  module ClassMethods
    
    def acts_as_multiply_category
      
        # Нет возможности вклиниться в фильры и установить cache_count параметры
  
      # Для ассоциаций возможны следующие коллбэки: +before_add+, +after_add+, +before_remove+ и +after_remove+.
  
      has_many :child_categories, :class_name=>'CategoriesCategory', :foreign_key=>'parent_id'#, :dependent => :destroy
      has_many :parent_categories, :class_name=>'CategoriesCategory',  :foreign_key=>'child_id',#, :dependent => :destroy
      :after_remove => :after_remove_parent,
      :after_add => :after_add_parent
      
      has_many :children, :through=>:child_categories, :order => 'position'
      has_many :parents, :through=>:parent_categories, :order => 'position'
      
      #,
#      :after_add => :after_add_parent, 
#      :after_remove => :after_remove_parent
      
      # Не работает c.parents << p без ID в ассоциации


      
#       has_and_belongs_to_many :children, :class_name=>'Category', 
#       :foreign_key => 'parent_id', :association_foreign_key => 'child_id', :uniq=>true, :validate=>true #, :autosave=>true
      
#       has_and_belongs_to_many :parents, :class_name=>'Category', 
#       :foreign_key => 'child_id', :association_foreign_key => 'parent_id', :uniq=>true, :validate=>true, #, :autosave=>true,
# #      :before_add => :before_add, 
#       :after_add => :after_add_parent, 
# #      :before_remove => :before_remove, 
#       :after_remove => :after_remove_parent
      
      named_scope :roots, { 
        :conditions => "parents_count=0 OR parents_count is NULL",
        :order => :position
      }
      
      # TODO parents_count и children_count устанавливать в 0, если nil
      # TODO Проверять зацикливания
      # TODO ancestors - список предков
      
      
      #   extend ClassMethodsMixin
      include InstanceMethods      

    end
    
  end
  
  module ClassMethodsMixin
  end
  
  module InstanceMethods
    
    def ancestors
      node, nodes = self, []
      nodes << node = node.parent while node.parent
      nodes
    end

    # Returns the root node of the tree.
    def root
      node = self
      node = node.parent while node.parent
      node
    end

    def paths
      #    p=[]
      parent_paths.map { |p| p.join(' / ') }.join(' ; ')
    end

    def parent
      parents.size>0 ? parents[0] : nil
    end
    
    def parent_paths(self_name=false)
      pa=[]
      parents.map { |parent|
        p = parent.parent_paths(true)
        pa+=p if p
      }
      
      if self_name
        parent_paths.map { |p| p << self.name }
        parent_paths.empty? ? [[self.name]] : pa
      else
        pa.empty? ? [[]] : pa
      end
      parent_paths
    end

    
    
    private
    
    
    def after_add_parent(parent)
      p "after_add"
      # self.update_attributes({:parents_count,parents(true).count})
      # parent.update_attributes!({:children_count,children(true).count})
      # return true
    end
    
    def after_remove_parent(parent)
      p "after_remove"
      self.update_attributes({:parents_count=>parents(true).count})
      parent.update_attributes!({:children_count=>children(true).count})
      return true
    end
    
  end
end

ActiveRecord::Base.send :include, ActsAsMultiplyCategory
