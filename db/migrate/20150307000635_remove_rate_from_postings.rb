class RemoveRateFromPostings < ActiveRecord::Migration
  def change
    remove_column :postings, :rate
  end
end
