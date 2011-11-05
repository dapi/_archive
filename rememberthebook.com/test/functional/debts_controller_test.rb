require 'test_helper'


class DebtsControllerTest < ActionController::TestCase
  
  # def test_index
  #   get :index
  #   assert_template 'index'
  # end
  
  # def test_show
  #   get :show, :id => Debt.first
  #   assert_template 'show'
  # end
  
  # def test_new
  #   get :new
  #   assert_template 'new'
  # end
  
  # def test_create_invalid
  #   Debt.any_instance.stubs(:valid?).returns(false)
  #   post :create
  #   assert_template 'new'
  # end
  
  # def test_create_valid
  #   Debt.any_instance.stubs(:valid?).returns(true)
  #   post :create
  #   assert_redirected_to debt_url(assigns(:debt))
  # end
  
  # def test_edit
  #   get :edit, :id => Debt.first
  #   assert_template 'edit'
  # end
  
  # def test_update_invalid
  #   Debt.any_instance.stubs(:valid?).returns(false)
  #   put :update, :id => Debt.first
  #   assert_template 'edit'
  # end
  
  # def test_update_valid
  #   Debt.any_instance.stubs(:valid?).returns(true)
  #   put :update, :id => Debt.first
  #   assert_redirected_to debt_url(assigns(:debt))
  # end
  
  # def test_destroy
  #   debt = Debt.first
  #   delete :destroy, :id => debt
  #   assert_redirected_to debts_url
  #   assert !Debt.exists?(debt.id)
  # end
end
