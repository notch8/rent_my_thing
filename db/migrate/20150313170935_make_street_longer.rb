class MakeStreetLonger < ActiveRecord::Migration
  def change
    change_column :postings, :street, :string, limit: nil
  end
end
