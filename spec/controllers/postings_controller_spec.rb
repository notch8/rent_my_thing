require 'rails_helper'

RSpec.describe PostingsController do
  describe "GET index" do
    it "assigns @postings" do
      posting = Posting.create
      get :index
      expect(assigns(:postings)).to eq([posting])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end
end
