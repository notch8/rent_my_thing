class Posting < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :reservations
  has_many :reviews


  ratyrate_rateable "title"
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

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

  def image?
    self.uploads.present?
  end

  def image
    if image?
      self.uploads.first
    else
      self.uploads.build
    end
  end
end
