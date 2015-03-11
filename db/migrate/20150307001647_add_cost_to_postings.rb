class AddCostToPostings < ActiveRecord::Migration
  def change
    add_column :postings, :cost, :decimal, precision: 8, scale: 2
  end
end
