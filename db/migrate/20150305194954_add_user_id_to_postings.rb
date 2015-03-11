class AddUserIdToPostings < ActiveRecord::Migration
  def change
    change_table :postings do |t|
      t.references :user
    end
  end
end
