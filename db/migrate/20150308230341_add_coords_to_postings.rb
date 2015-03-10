class AddCoordsToPostings < ActiveRecord::Migration
  def up
    Posting.connection.execute """
      ALTER TABLE postings ADD coords GEOMETRY(point)
    """
  end

  def down
    Posting.connection.execute """
      ALTER TABLE postings DROP COLUMN coords
    """
end
