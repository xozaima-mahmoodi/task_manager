# spec/controllers/tasks_controller_spec.rb
require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns all tasks as @tasks' do
      task1 = create(:task, title: 'Buy groceries')
      task2 = create(:task, title: 'Pay bills')

      get :index
      expect(assigns(:tasks)).to eq([task1, task2])
    end
  end
end