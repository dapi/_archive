#!/usr/bin/ruby
require  File.dirname(__FILE__) + '/../config/environment'
require 'pp'

Branch.destroy_all
CompanyGroup.destroy_all

pp "Destroied"

pp "Make branches and groups"
Category.all.map { |c|
 if c.children.size>0 
	 b=Branch.create({:name=>c.name})
   g=CompanyGroup.create({:name=>c.name})
   g.branches << b
  else 
	 CompanyGroup.create({:name=>c.name})
  end
}

pp "Create relationships"
Category.all.map { |c|
	if c.parent_id
		parent=Branch.find_by_name(c.parent.name) # || raise "No parent #{c.parent_id}"
		if c.children.size>0
			b=Branch.find_by_name(c.name)
			b.parent_id=parent.id
		else
			g=CompanyGroup.find_by_name(c.name)
			g.branches << parent
		end
	end
}
