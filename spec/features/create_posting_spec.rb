require "rails_helper"

RSpec.feature "Posting creation" do
  before :each do

    @category = Category.create name: 'Test category'
    User.create!(:email => 'user@example.com', :password => 'password')
  end
  scenario "User creates a new posting" do
    visit "/users/sign_in"

    fill_in "Email", with: "user@example.com"
    fill_in "Password", with: "password"
    click_button "Log in"

    visit "/postings/new"

    fill_in "Title", with: "Test Posting"
    fill_in "Description", with: "Test posting description"

    click_button "Update Posting"

    expect(page).to have_content("Test posting description")
  end
end
