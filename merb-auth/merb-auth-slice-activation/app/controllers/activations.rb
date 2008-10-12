class MerbAuthSliceActivation::Activations <  MerbAuthSliceActivation::Application

  def activate
    redirect "/", :message => "Activation Successfully"
  end

end
