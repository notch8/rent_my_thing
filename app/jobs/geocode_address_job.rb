class GeocodeAddressJob < ActiveJob::Base
  queue_as :default

  def perform(record)
    address = record.geocode

  end
end
