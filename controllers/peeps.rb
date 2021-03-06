require 'sinatra/base'
require 'sinatra/flash'

class ChitterApp < Sinatra::Base
  set :root, File.join(File.dirname(__FILE__), '..')

  post '/peeps' do
    unless params[:peep_text].empty?
      settings.peep_feed.post_peep(settings.current_user, params[:peep_text])
    end
    redirect '/'
  end

  get '/peeps/:id' do
    @chosen_peep = settings.peep_feed.get_peep(params[:id])
    @current_user = settings.current_user
    erb :individual_peep
  end

  post '/peeps/:id' do
    settings.peep_feed.reply_peep(settings.current_user, params[:reply_content],
                                  params[:id])
    redirect '/'
  end
  
  run! if app_file == $0
end
