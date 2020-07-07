class HomeController < ApplicationController
  require 'rubygems'
  require 'pp'
  require 'jira-ruby'

  def index
    # Consider the use of :use_ssl and :ssl_verify_mode options if running locally
    # for tests.

    # NOTE basic auth no longer works with Jira, you must generate an API token, to do so you must have jira instance access rights. You can generate a token here: https://id.atlassian.com/manage/api-tokens

    # You will see JIRA::HTTPError (JIRA::HTTPError) if you attempt to use basic auth with your user's password

    # username = 'shrevish95@gmail.com'
    # api_token = '67RSLPBuprUsVDeijYw844A2'

    username = "kanakshrma52@gmail.com"
    api_token = 'aFzWAvrIUd859Hf5oVHzF8C4'

    options = {
                username: username,
                password: api_token,
                site: 'https://regionalhero.atlassian.net/', # or 'https://<your_subdomain>.atlassian.net/'
                context_path: '', # often blank
                auth_type: :basic
              }

    client = JIRA::Client.new(options)

    # Show all projects
    @projects = client.Project.all
  end
end
