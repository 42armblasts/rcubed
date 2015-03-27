require 'rubygems'
require 'sinatra/base'
require 'mysql2'
require 'active_record'
require 'yaml'

database_config = if ENV['DATABASE_URL']
  ENV['DATABASE_URL']
else
  YAML.load(File.read('database.yml'))
end
ActiveRecord::Base.establish_connection(database_config)
Dir["models/*.rb"].each { |file| load file }

Tilt.register Tilt::ERBTemplate, 'html.erb'

class SinatraBootstrap < Sinatra::Base

  get '/' do
    @publishers = Publisher.active
    erb :index
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end