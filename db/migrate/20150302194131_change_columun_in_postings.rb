class ChangeColumunInPostings < ActiveRecord::Migration
  def change
    change_column :postings, :street, :string, :limit => 20 

  end
end
