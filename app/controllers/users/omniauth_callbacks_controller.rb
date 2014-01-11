class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.find_for_google_oauth2(auth_hash,
                                        current_user)

    if @user.persisted?
      flash[:notice] = I18n.t('devise.omniauth_callbacks.success',
                              kind: 'Google')

      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.google_data'] = auth_hash
      redirect_to new_user_registration_url
    end
  end

  def facebook
    redirect_to user_omniauth_authorize_path(:google_oauth2) unless current_user

    uid = auth_hash['uid']
    creds = auth_hash['credentials']
    attrs = {
      facebook_uid: uid,
      facebook_token: creds['token'],
      facebook_token_expires_at: creds['expires_at']
    }
    current_user.update_attributes(attrs)

    flash[:notice] = I18n.t('devise.omniauth_callbacks.success',
                            kind: 'Facebook')

    redirect_to services_path
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
