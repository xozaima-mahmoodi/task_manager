require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'is valid with a title' do
    task = Task.new(title: 'Learn RSpec')
    expect(task).to be_valid
  end

  it 'is invalid without a title' do
    task = Task.new(title: nil)
    expect(task).to_not be_valid
    expect(task.errors[:title]).to include("can't be blank")
  end

   it 'defaults completed to false' do
    task = Task.new(title: 'Test default completed')
    expect(task.completed).to be false
  end
end
