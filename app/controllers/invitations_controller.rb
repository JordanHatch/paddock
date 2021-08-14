class InvitationsController < ApplicationController
  skip_before_action :authenticate!
  before_action :redirect_if_signed_in, except: :sign_out

  layout 'unauthenticated'

  def new; end

  def create
    invitation = Invitation.new(
      email: params[:email],
    )

    if invitation.save
      SendInvitationEmailJob.perform_later(invitation)
      redirect_to sent_invitation_path
    else
      flash.alert = 'Sorry, please sign in with an @awe.gov.au email address.'
      redirect_to new_invitation_path
    end
  end

  def redeem
    redirect_on_token_error unless token.present?
  end

  def do_redeem
    if token.present? && token.redeem
      session[:user_id] = User.find_or_create_by(email: token.email).id
      redirect_to root_path
    else
      redirect_on_token_error
    end
  end

  def sign_out
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  helper_method :token

  def token
    @token ||= Invitation.active.find_by_token(params[:token])
  end

  def redirect_if_signed_in
    redirect_to root_path if signed_in?
  end

  def redirect_on_token_error
    flash.alert = 'Sorry, this token is not valid'
    redirect_to new_invitation_path
  end
end
