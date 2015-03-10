class AddCoordsToPostings < ActiveRecord::Migration
  def change
    change_table :postings do |t|
      t.point :coords
    end
  end
end
