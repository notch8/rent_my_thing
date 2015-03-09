class Posting < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :reservations
  has_many :reviews

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

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
        self.update_column :coords, "POINT(#{lon} #{lat})"
        # save validate: false
      end
    end
  end
end
