# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require 'tilt/erubis'
require 'dotenv/load'
require 'bcrypt'
require 'sinatra/content_for'
require_relative 'app.rb'

Dotenv.load

configure do
  enable(:sessions)
  set(:session_secret, ENV['SECRET'])
  set(:views, '../views')
end

def valid_login?(username, password)
  username == ENV['USERNAME'] && BCrypt::Password.new(ENV['PASSWORD']) == password
end

get '/' do
  erb(:home)
end

get '/users/login' do
  erb(:login)
end

post '/users/login' do
  redirect '/' if valid_login?(params[:username], params[:password])
  
  session[:message] = "Incorrect login details; please try again"
  status 422
  erb(:login)
end

get '/contact' do
  erb(:contact)
end
