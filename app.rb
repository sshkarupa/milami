require 'sinatra'
require 'sinatra/reloader' if development?
require 'slim'
require 'sass'
require 'pony'
require 'dotenv'

get('/styles.css'){ sass :styles, style: :compressed, views: './public/sass' }

Dotenv.load

configure do
  set via_options: {
    address: 'smtp.gmail.com',
    port: '587',
    user_name: ENV['USER_NAME'] ,
    password: ENV['USER_PASSWORD'],
    authentication: :plain,
    domain: 'mail.gmail.com'
    }
end

helpers do
  def send_email(info, email)
    options = {
      to: ENV['SEND_TO'],
      from: "milami.cc <#{ENV['USER_NAME']}>",
      subject: "new contact",
      body: "#{info} : #{email}",
      via: :smtp,
      via_options: settings.via_options }
    thr = Thread.new { Pony.mail(options) }
  end
end

get '/' do
  slim :index
end

get '/reset' do
  slim :reset, layout: (request.xhr? ? false : :layout)
end

post '/reset' do
  sleep 1
  send_email('Reset password', params[:email])
  slim :reset_sent
end

get '/signup' do
  puts ENV['SEND_TO']
  slim :signup
end

post '/signup' do
  send_email('Ask invite', params[:email])
  slim :signup_sent
end

not_found do
  slim :'404'
end
