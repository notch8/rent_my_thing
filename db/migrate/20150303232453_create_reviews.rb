class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :posting
      t.string :review
      t.text :user_id


      t.timestamps null: false
    end
  end
end
