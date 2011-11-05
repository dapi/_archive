# -*- coding: utf-8 -*-
require 'test_helper'

class CategoryTest < Test::Unit::TestCase
  #  should_belong_to :parent
  
  should_have_many :children
  should_have_many :parents

  should_have_many :companies
  
  should_validate_presence_of :name
#  should_not_allow_values_for :phone_number, "abcd", "1234"
# should_allow_values_for :phone_number, "(123) 456-7890"

#  should_validate_presence_of :description
  
  # TODO Категоричные тесты

  # context "A Category class" do
  #   setup do
  #     Category.destroy_all
  #     @category_1     = Factory.create(:category)
  #     @category_2     = Factory.create(:category)
  #     @category_3     = Factory.create(:category)
  #     @category_2_1   = Factory.create(:category, :parent_id => @category_2.id, :name => 'category_2_1')
  #     @category_2_2   = Factory.create(:category, :parent_id => @category_2.id, :name => 'category_2_2')
  #     @category_2_1_1 = Factory.create(:category, :parent_id => @category_2_1.id, :name => 'category_2_1_1')
  #   end

  #   should "return sorted categories" do
  #     assert_equal 6, Category.find(:all).size
  #     assert_equal @category_2.id, @category_2_2.parent.id
  #     sorted_categories = Category.sorted
  #     [@category_1, @category_2, @category_2_1, @category_2_1_1, @category_2_2, @category_3].each_with_index do |cat, i|
  #       assert_equal cat, sorted_categories[i]
  #     end
  #   end

  #   should "return categories for select except defined" do
  #     selected = Category.all_for_select(@category_2_1)
  #     [nil, @category_1, @category_2, @category_2_1_1, @category_2_2, @category_3].each_with_index do |cat, i|
  #       if cat
  #         assert_equal cat.id, selected[i].last
  #       else
  #         assert_equal nil, selected[i].last
  #       end
  #     end
  #   end

#end
end
