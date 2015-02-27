class Category < ActiveRecord::Base
  validates_presence_of :name
  has_many :posting

  accepts_nested_attributes_for :posting,
  :allow_destroy => true,
  :reject_if => :all_blank

end
