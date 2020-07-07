class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  require 'openssl'

  protect_from_forgery

  rescue_from JIRA::OauthClient::UninitializedAccessTokenError do
    redirect_to new_jira_session_url
  end

  private

  def get_jira_client
    # add any extra configuration options for your instance of JIRA,
    # e.g. :use_ssl, :ssl_verify_mode, :context_path, :site
    username = 'shrevish95@gmail.com'
    api_token = '67RSLPBuprUsVDeijYw844A2'

    options = {
      username: username,
      password: api_token,
      site: 'https://regionalhero.atlassian.net/',
      private_key_file: 'jira_privatekey.pem',
      consumer_key: 'OauthKey',
      context_path: ''
    }

    @jira_client = JIRA::Client.new(options)

    # Add AccessToken if authorised previously.
    if session[:jira_auth]
      @jira_client.set_access_token(
        session[:jira_auth]['access_token'],
        session[:jira_auth]['access_key']
      )
    end
  end
end
