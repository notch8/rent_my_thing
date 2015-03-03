class PostingsController < ApplicationController
  before_action :set_date_range, only: [:create, :update]
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy ]
  before_action :load_categories, only: [:show, :edit, :new ]
  before_action :set_posting, only: [:show, :edit, :update, :destroy]

  # GET /postings
  # GET /postings.json
  def index
    @postings = Posting.all
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
    fields = posting_params
    fields[:available_dates] = @available_dates if @available_dates

    params["posting"]["category_id"] = params["Category"]
    # logger.debug "date range: #{params["rentrange"]["from"]} to #{params["rentrange"]["to"]} "
    @posting = Posting.new(fields)

    respond_to do |format|
      if @posting.save
        format.html { redirect_to @posting, notice: 'Posting was successfully created.' }
        format.json { render :show, status: :created, location: @posting }
      else
        format.html { render :new }
        format.json { render json: @posting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /postings/1
  # PATCH/PUT /postings/1.json
  def update
    fields = posting_params
    fields[:available_dates] = @available_dates if @available_dates
    respond_to do |format|
      if @posting.update(fields)
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
      params.require(:posting).permit(:title, :description, :category_id, :rate, :street, :state, :zip, :phone, :email)
    end

    def get_date_range
      if params[:rentrange]
        from = params[:rentrange][:from]
        to = params[:rentrange][:to]
        if from.blank?
          from = Date.today
        else
          from = Date.strptime from, '%m/%d/%Y'
        end
        if to.blank?
          range = from..(Date.today + 1.year)
        else
          to = Date.strptime to, '%m/%d/%Y'
          range = from..to
        end
        @available_dates = range
      end
    end
end
