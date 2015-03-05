class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /reservations
  # GET /reservations.json
  def index
    @reservations = Reservation.all
  end

  # GET /reservations/1
  # GET /reservations/1.json
  def show
  end

  # GET /reservations/new
  def new
    @reservation = Reservation.new
    @posting = Posting.find params[:posting_id]
    #parse params[:reservation] and assign to @reservation
    res = params[:reservation].split ' - '
    start = Date.strptime res[0], '%m/%d/%Y'
    finish = Date.strptime res[1], '%m/%d/%Y'
    @reservation.when = start..finish
  end

  # GET /reservations/1/edit
  def edit
  end

  # POST /reservations
  # POST /reservations.json
  def create
    res_params = reservation_params
    res_when = res_params.delete :when
    if res_when
      res_dates = res_when.split('..')
      res_start = Date.strptime res_dates[0], '%Y-%m-%d'
      res_end = Date.strptime res_dates[1], '%Y-%m-%d'
      res_params[:when] = res_start..res_end
    end
    @reservation = Reservation.new(res_params)
    @reservation.posting_id = params[:posting_id]
    @reservation.user = current_user

    respond_to do |format|
      if @reservation.save
        logger.debug "Reservation: #{@reservation.when.first} to #{@reservation.when.last}"
        logger.debug "Got reservation: #{@reservation.inspect}"
        MailerGenerator.send_reservation_email("id" => @reservation.id)
        format.html { redirect_to @reservation, notice: 'Congratulations on your rental!' }
        format.json { render :show, status: :created, location: @reservation }
      else
        format.html { render :new }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reservations/1
  # PATCH/PUT /reservations/1.json
  def update
    respond_to do |format|
      if @reservation.update(reservation_params)
        format.html { redirect_to @reservation, notice: 'Reservation was successfully updated.' }
        format.json { render :show, status: :ok, location: @reservation }
      else
        format.html { render :edit }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  def destroy
    @reservation.destroy
    respond_to do |format|
      format.html { redirect_to reservations_url, notice: 'Reservation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reservation_params
      params.require(:reservation).permit(:user_id, :posting_id, :when)
    end
end
