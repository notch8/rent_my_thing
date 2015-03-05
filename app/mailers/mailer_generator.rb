class MailerGenerator < ActionMailer::Base
  before_action :set_reservation, only: [ :send_reservation_email ]
  default from: "customer_service@rent-my-thing.com"
  layout 'mailer'

  def sample
    mail( :to => "jmo@olen-inc.com", :subject => "testing email from rent_my_thing")
  end

  def send_reservation_email
    layout 'reserve_create'
    subject_text = "Your Rent_My_Thing reservation"
    mail( :to => @reservation.user.email, :subject => subject_text ).deliver
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.includes(:user, :posting).find(params[:id])
    end

end
