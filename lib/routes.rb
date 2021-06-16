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
  set(:views, File.expand_path('../views', __dir__))
end

helpers do
  def display_key(key)
    key.to_s.split('_').map(&:capitalize).join(' ')
  end

  def display_value(value)
    return value unless value.instance_of?(Array)
    value.flatten.join(', ')
  end
end

def valid_login?(username, password)
  username == ENV['USERNAME'] && BCrypt::Password.new(ENV['PASSWORD']) == password
end

def valid_name?(name)
  !name.match(/\d/)
end

def valid_phone_num?(phone_num)
  !phone_num.match(/\D/) && phone_num.length == 10
end

def valid_address?(address)
  address.match(/\D/) && address.match(/\d/)
end

def validate_login_status
  return if session[:login]

  session[:message] = 'You need to be logged in to do that.'
  redirect '/users/login'
end

get '/' do
  validate_login_status

  session[:contact_list] = Book.new(session[:username]) if session[:contact_list].nil?
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

  session[:message] = 'Incorrect login details; please try again'
  status 422
  erb(:login)
end

post '/users/logout' do
  session.delete(:login)
  session[:message] = 'You have been logged out.'
  redirect '/users/login'
end

get '/new' do
  validate_login_status
  erb(:new_contact)
end

post '/new' do
  # Bug: For some reason, any string with a space that's captured as part of the params hash does not fully return when the form is invalid.
  # I have tried capturing the value as an instance variable, but this does not seem to make a difference.
  # I suspect it's something to do with spaces not being escaped properly?
  @categories = params[:categories].split(',')

  if valid_name?(params[:name]) && valid_phone_num?(params[:phone_num]) &&
    valid_address?(params[:address])
    session[:contact_list].add_contact(params[:name], params[:phone_num], params[:address], @categories)
    session[:message] = "Contact for #{params[:name]} successfully created."
    redirect '/'
  end

  status 422
  session[:message] = 'Invalid field detected! Please check and try again.'
  erb(:new_contact)
end
