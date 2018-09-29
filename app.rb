require 'sinatra/base'
require 'sinatra/flash'
require_relative 'lib/all_users'
require_relative 'lib/user'

class ChitterApp < Sinatra::Base
  use Rack::Session::Pool

  register Sinatra::Flash

  configure do
    set :users, AllUsers.new
    set :current_user, User.new
  end

  # not_found do
  #   status 404
  #   erb :'404Page'
  # end

  get '/' do
    @current_user = settings.current_user
    erb :index
  end

  get '/users/new' do
    erb :new_user
  end

  post '/users' do
    @users = settings.users
    entry_hash = { name: params[:name], email: params[:email],
                   username: params[:username], password: params[:password] }
    error_message = 'Invalid sign up details, please try again'
    success_message = 'You are now signed up to Chitter!'
    if @users.create(entry_hash)
      flash[:sign_up_message] = success_message
    else
      flash[:sign_up_message] = error_message
    end
    redirect '/'
  end

  post '/log_in' do
    # Need to fix error if username or password is nil
    @users = settings.users
    if @users.sign_in(params[:username], params[:password])
      flash[:correct_sign_in?] = "You are now signed in as #{params[:username]}"
      settings.current_user.log_in(params[:username])
    else
      flash[:correct_sign_in?] = 'Incorrect login details, please try again.'
    end
    redirect '/'
  end

  post '/log_out' do
    settings.current_user.log_out
    flash[:logged_out] = 'You are now logged out.'
    redirect '/'
  end

  run! if app_file == $0
end
