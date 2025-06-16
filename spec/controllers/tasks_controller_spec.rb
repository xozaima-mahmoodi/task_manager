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

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end

    it 'assigns a new task as @task' do
      get :new
      expect(assigns(:task)).to be_a_new(Task)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new Task' do
        expect {
          post :create, params: { task: attributes_for(:task) }
        }.to change(Task, :count).by(1)
      end

      it 'redirects to the created task' do
        post :create, params: { task: attributes_for(:task) }
        expect(response).to redirect_to(Task.last)
      end

      it 'sets a flash notice' do
        post :create, params: { task: attributes_for(:task) }
        expect(flash[:notice]).to eq 'Task was successfully created.'
      end
    end

    context 'with invalid parameters' do
      it 'does not save the new task' do
        expect {
          post :create, params: { task: attributes_for(:task, title: nil) }
        }.to_not change(Task, :count)
      end

      it 'returns a success response (i.e. to display the "new" template)' do
        post :create, params: { task: attributes_for(:task, title: nil) }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end

      it 'does not set a flash notice' do
        post :create, params: { task: attributes_for(:task, title: nil) }
        expect(flash[:notice]).to be_nil
      end
    end
  end
end