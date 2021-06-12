# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require 'tilt/erubis'
require 'dotenv/load'
require 'bcrypt'
require 'sinatra/content_for'
require_relative 'app'

Dotenv.load

configure do
  enable(:sessions)
  set(:session_secret, 'abc')
  # set(:session_secret, ENV['SECRET'])
  set(:views, File.expand_path('../../views', __FILE__))
end

def print_hello
  "Welcome #{session[:username]}!"
end

def valid_login?(username, password)
  # username == ENV['USERNAME'] && BCrypt::Password.new(ENV['PASSWORD']) == password
  username == 'admin' && password == 'secret'
end

get '/' do
  if !session[:username]
    session[:message] = 'You need to be logged in to do that.'
    redirect '/users/login' 
  end
  erb(:home)
end

get '/users/login' do
  erb(:login)
end

post '/users/login' do
  if valid_login?(params[:username], params[:password])
    session[:login] = 'success'
    session[:username] = params[:username]
    redirect '/' 
  end

  session[:message] = "Incorrect login details; please try again"
  status 422
  erb(:login)
end

get '/contact' do
  erb(:contact)
end
