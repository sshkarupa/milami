#\ -w -o 0.0.0.0 -p 3000 # указать желаемый порт

require './app.rb' # подгрузить app.rb
run Sinatra::Application # запустить приложение
