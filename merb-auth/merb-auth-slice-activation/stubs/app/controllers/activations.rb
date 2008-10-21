class MerbAuthSliceActivation::Activations <  MerbAuthSliceActivation::Application

  after :redirect_after_activation

  # Activate a user from the submitted activation code.
  #
  # ==== Returns
  # String:: Empty string.
  def activate
    session.user = Merb::Authentication.user_class.find_with_activation_code(params[:activation_code])
    if session.authenticated? && !session.user.activated?
      Merb.logger.info "Activated #{current_ma_user}"
      session.user.activate
    end
    ""
  end

  private

  def redirect_after_activation
    redirect "/", :message => {:notice => "Activation Successful"}
  end

end # MerbAuthSliceActivation::Activations
