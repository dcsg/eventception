RSpec.describe "TodoList example" do
  it 'runs without error' do
    load File.expand_path('../../../examples/todo_list/run.rb', Pathname.new(__FILE__).realpath)
  end
end
