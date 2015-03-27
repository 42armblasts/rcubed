require 'rubygems'
require 'sinatra/base'

Tilt.register Tilt::ERBTemplate, 'html.erb'

class SinatraBootstrap < Sinatra::Base

  get '/' do
    erb :index
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end