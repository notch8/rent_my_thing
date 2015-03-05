class Posting < ActiveRecord::Base
  belongs_to :category
  has_many :reservations
  has_many :reviews
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  self.per_page = 10
end
