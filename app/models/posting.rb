class Posting < ActiveRecord::Base
  belongs_to :category
  has_many :reservations
end
