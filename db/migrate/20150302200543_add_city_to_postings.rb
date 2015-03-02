class AddCityToPostings < ActiveRecord::Migration
  def change
    add_column :postings, :city, :string, :limit =>30
  end
end
