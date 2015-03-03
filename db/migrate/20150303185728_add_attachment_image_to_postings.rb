class AddAttachmentImageToPostings < ActiveRecord::Migration
  def self.up
    change_table :postings do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :postings, :image
  end
end
