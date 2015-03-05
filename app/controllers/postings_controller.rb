class PostingsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy ]
  before_action :load_categories, only: [:show, :edit, :new ]
  before_action :set_posting, only: [:show, :edit, :update, :destroy]
  layout :resolve_layout

  def resolve_layout
    if action_name == "splash" 
      "splash"
    else
      "application"
    end
  end

  def splash
  end

  # GET /postings
  # GET /postings.json
  def index
    @postings = Posting.all.includes :category
    start_date = params[:start_date]
    end_date = params[:end_date]
    category_id = params[:category_id]
    search_string = params[:search_text]
    start_date = Date.strptime start_date, '%Y-%m-%d' if start_date.present?
    end_date = Date.strptime end_date, '%Y-%m-%d' if end_date.present?
    city = params[:city]

    @postings = Posting.paginate(:page => params[:page])


    if start_date.present? && end_date.present?
      @postings = @postings.where "available_dates && [?, ?)", start_date, end_date
    elsif start_date.present?
      @postings = @postings.where "?::date <@ available_dates", start_date
    elsif end_date.present?
      @postings = @postings.where "?::date <@ available_dates", end_date
    end

    if search_string.present?
      @postings = @postings.where "POSITION(:str in title) <> 0 OR POSITION(:str in description) <> 0", {str: search_string}
    end

    if category_id.present?
      @postings = @postings.where category_id: category_id
    end

    if city.present?
      @postings = @postings.where "lower(city) = lower(?)", city
    end
  end

  # GET /postings/1
  # GET /postings/1.json
  def show
  end

  # GET /postings/new
  def new
    @posting = Posting.new
  end

  # GET /postings/1/edit
  def edit
  end

  # POST /postings
  # POST /postings.json
  def create
    # logger.debug "date range: #{params["rentrange"]["from"]} to #{params["rentrange"]["to"]} "
    @posting = Posting.new(posting_params)

    respond_to do |format|
      if @posting.save
        format.html { redirect_to @posting, notice: 'Posting was successfully created.' }
        format.json { render :show, status: :created, location: @posting }
      else
        load_categories
        format.html { render :new }
        format.json { render json: @posting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /postings/1
  # PATCH/PUT /postings/1.json
  def update
    respond_to do |format|
      if @posting.update(posting_params)
        format.html { redirect_to @posting, notice: 'Posting was successfully updated.' }
        format.json { render :show, status: :ok, location: @posting }
      else
        format.html { render :edit }
        format.json { render json: @posting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /postings/1
  # DELETE /postings/1.json
  def destroy
    @posting.destroy
    respond_to do |format|
      format.html { redirect_to postings_url, notice: 'Posting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def load_categories
      @categories = Category.all
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_posting
      @posting = Posting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def posting_params
      params.require(:posting).permit(:title, :description, :category_id, :rate,
          :date_range, :street, :state, :zip, :phone, :email, :city)
    end
end
