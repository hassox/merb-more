class MerbAuthSliceActivation::ActivationMailer < Merb::MailController

  def signup
    @user = params[:user]
    Merb.logger.info "Sending Signup to #{@user.email} with code #{@user.activation_code}"
    render_mail :text => :signup, :layout => nil
  end

  def activation
    @user = params[:user]
    Merb.logger.info "Sending Activation email to #{@user.email}"
    render_mail :text => :activation, :layout => nil
  end

end