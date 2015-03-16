require 'rails_helper'

RSpec.describe Posting do
  before do
    @category = Category.create id: 1, name: 'test category'
  end
  context "with address" do
    it "schedules geocoding after saving" do
      post = Posting.new title: 'test posting', description: 'test posting description', category_id: 1, street: '3805 Ray St', city: 'San Diego', zip: '92014'

      expect_any_instance_of(GeocodeAddressJob).to receive :perform
      post.save!
    end
  end
end
