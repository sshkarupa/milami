require 'sinatra'
require 'slim'
require 'sass'
require "pony"

get('/styles.css'){ sass :styles, :style => :compressed, :views => './public/sass' }

configure do
  set :send_to, 'to_email@email.com'
  set :via_options => {
    :address         => 'smtp.gmail.com',
    :port            => '587',
    :user_name       => 'user@gmail.com',
    :password        => 'password',
    :authentication  => :plain,
    :domain          => "mail.gmail.com"
    }
end

helpers do
  def send_email(info, email)
    options = {
      :to => settings.send_to,
      :from => "Milami <#{settings.via_options[:user_name]}>",
      :subject => "new contact",
      :body => "#{info} : #{email}",
      :via => :smtp,
      :via_options => settings.via_options }
    thr = Thread.new { Pony.mail(options) }
  end
end

get '/' do
  slim :index
end

get '/reset' do
  slim :reset, :layout => (request.xhr? ? false : :layout)
end

post '/reset' do
  sleep 1
  send_email('Reset password', params[:email])
  slim :reset_sent
end

get '/signup' do
  slim :signup
end

post '/signup' do
  send_email('Ask invite', params[:email])
  slim :signup_sent
end

not_found do
  slim :'404'
end
