Bundler.require

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

require 'sinatra/asset_pipeline'

class SinatraBootstrap < Sinatra::Base
  register Sinatra::AssetPipeline

  get '/' do
    @publishers = Publisher.active.order(name: :asc)
    erb :index
  end

  get '/daily-revenue/:publisher_id.json' do
    content_type :json

    order_scope = Order.where('created_at > ?', 1.week.ago.beginning_of_day).where(publisher_id: params[:publisher_id])
    earnings_scope = Earning.where('created_at > ?', 1.week.ago.beginning_of_day).where(earner_type: "Publisher", earner_id: params[:publisher_id])
    order_earnings = order_scope.pluck(:price_in_cents).sum

    {
      order_count: order_scope.count,
      total_revenue: order_earnings,
      net_rev_margin: ((order_earnings - earnings_scope.pluck(:amount_in_cents).sum).to_f / order_earnings.to_f * 100).round(2)
    }.to_json
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
