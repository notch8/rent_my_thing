class Posting < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :reservations
  has_many :reviews
  has_many :uploads

  self.per_page = 10

  after_save do
    GeocodeAddressJob.perform_later self
  end

  def address
    "#{street}, #{city}, #{state} #{zip}"
  end

  def geocode
    if street.present? && city.present? && state.present?
      RentMyThing.geocode address do |lon, lat|
        self.update_column :coords, [lon, lat]
        # save validate: false
      end
    end
  end

  def image
    if self.uploads.present?
      self.uploads.first
    else
      self.uploads.build
    end
  end
end
