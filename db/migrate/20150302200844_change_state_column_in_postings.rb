class ChangeStateColumnInPostings < ActiveRecord::Migration
  def change
    change_column  :postings, :state, :string, :limit =>2
  end
end
