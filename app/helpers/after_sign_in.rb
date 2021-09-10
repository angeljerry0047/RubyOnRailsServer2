module AfterSignIn
  def after_sign_in_path_for(resource)
    if resource.sign_in_count == 1
      edit_user_registration_url(protocol: "https")
    else
      session[:previous_url] || root_url

    end
  end
end
