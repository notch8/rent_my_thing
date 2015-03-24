require "rails_helper"

RSpec.describe "postings/index.html.erb" do
  it "displays all the postings" do

    assign :postings, [
      stub_model(Posting, title: "stub title 1", description: 'stub description2'),
      stub_model(Posting, title: "stub title 2", description: 'stub description1')
    ]
    allow(view).to receive_messages(:will_paginate => nil)
    allow(view).to receive_messages(:current_user => nil)

    render

    expect(rendered).to match("stub title 1")
    expect(rendered).to match("stub description1")
  end
end
