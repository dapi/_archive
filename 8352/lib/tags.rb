# -*- coding: utf-8 -*-
Tag.class_eval do
  unloadable
  has_many :synonyms, :class_name=>"TagsSynonym"
  

end
