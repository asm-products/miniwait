source 'https://rubygems.org'

ruby '2.1.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.8'

# Use PostgreSQL as the database for Active Record
gem 'pg', '0.18.0.pre20141117110243'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

gem 'uglifier' # compression

gem 'pony' # easier email

gem 'figaro', '~> 0.7.0' # set ENV variables via application.yml

gem 'geocoder'

group :development do
   gem 'thin' # light-weight web server
   gem 'letter_opener' # view emails locally without sending
   gem 'dotenv-rails' # load ENV vars from .env file
   gem 'debase'
   gem 'better_errors'
end

# Need time zone info
gem 'tzinfo-data'

group :production do
   gem 'rails_12factor'
   gem 'unicorn'
   gem 'postmark'
end
