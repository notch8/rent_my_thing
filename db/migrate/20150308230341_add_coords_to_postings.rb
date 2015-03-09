class AddCoordsToPostings < ActiveRecord::Migration
  def change
    change_table :postings do |t|
      t.column :coords, :st_point
    end
  end
end
