class MerbAuthSliceActivation::ActivationMailer < Merb::MailController

  controller_for_slice MerbAuthSliceActivation, :templates_for => :mailer, :path => "views"

  def signup
    @ivar = params[MerbAuthSliceActivation[:single_resource]]
    Merb.logger.info "Sending Signup to #{@ivar.email} with code #{@ivar.activation_code}"
    instance_variable_set("@#{MerbAuthSliceActivation[:single_resource]}", @ivar)
    render_mail :text => :signup, :layout => nil
  end

  def activation
    @ivar = params[MerbAuthSliceActivation[:single_resource]]
    Merb.logger.info "Sending Activation email to #{@ivar.email}"
    instance_variable_set("@#{MerbAuthSliceActivation[:single_resource]}", @ivar)
    render_mail :text => :activation, :layout => nil
  end

end
