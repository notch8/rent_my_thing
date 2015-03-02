class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.references :user
      t.references :posting
      t.daterange :when

      t.timestamps null: false
    end
  end
end
