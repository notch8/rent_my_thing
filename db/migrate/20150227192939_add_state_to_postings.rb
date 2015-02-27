class AddStateToPostings < ActiveRecord::Migration
  def change
    add_column :postings, :state, :string
  end
end
