class UsersController < ApplicationController
  before_action :set_user

  def index
    @Users = Users.all

  end

  def show
    @postings = @user.postings
    @reviews = Review.where posting_id: @postings.map(&:id)
  end

  def postings user
    @Postings = User.postings
  end

  def reviews user
    @Reviews = User.reviews
  end

end

private
  def set_user
    @user = User.find(params[:id])
  end
