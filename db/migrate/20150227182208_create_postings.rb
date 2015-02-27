class CreatePostings < ActiveRecord::Migration
  def change
    create_table :postings do |t|
      t.string :title
      t.text :description
      t.references :category, index: true
      t.decimal :rate, precision: 8, scale: 2
      t.daterange :available_dates
      t.string :street, limit: 2
      t.string :zip, limit: 5
      t.string :phone
      t.string :email

      t.timestamps null: false
    end
    add_foreign_key :postings, :categories
  end
end
