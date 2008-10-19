class MerbAuthSliceActivation::Activations <  MerbAuthSliceActivation::Application
  after :redirect_after_activation

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
    redirect "/", :message => "Activation Successful"
  end

end
