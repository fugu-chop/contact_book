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

  def display_action
    request.path_info.split('/').last.capitalize
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

def valid_input?(name, phone_num, address)
  valid_name?(name) && valid_phone_num?(phone_num) && valid_address?(address)
end

def validate_login_status
  return if session[:login]

  session[:message] = 'You need to be logged in to do that.'
  redirect '/users/login'
end

def display_filtered_contacts(filtered_obj)
  filtered_book = Book.new('filtered')
  filtered_obj.each do |item|
    filtered_book.add_contact(item[:details][:name], item[:details][:phone_number], item[:details][:address],
                              item[:details][:category])
  end
  filtered_book
end

get '/' do
  validate_login_status

  session[:contact_list] = Book.new(session[:username]) if session[:contact_list].nil?
  @contacts = session[:contact_list]

  # Clear search term saved to session hash if it exists
  session.delete(:search_term)

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
  @list = {}
  validate_login_status
  erb(:contact)
end

post '/new' do
  @categories = params[:categories].split(',')

  if valid_input?(params[:name], params[:phone_num], params[:address])
    session[:contact_list].add_contact(params[:name], params[:phone_num], params[:address], @categories)
    session[:message] = "Contact for #{params[:name]} successfully created."
    redirect '/'
  end

  status 422
  session[:message] = 'Invalid field detected! Please check and try again.'
  erb(:contact)
end

post '/:contact/delete' do
  idx = params[:contact].to_i

  deleted_contact = session[:contact_list].delete_contact(idx)
  session[:message] = "#{deleted_contact[:details][:name]} deleted from contacts."
  redirect '/'
end

post '/search' do
  search_term = params[:search_name]
  filtered_obj = session[:contact_list].filter_contacts(search_term)

  if filtered_obj.empty?
    search_term = params[:search_name]
    session[:message] = "The '#{search_term}' search term was not found."
    session[:search_term] = search_term
    redirect '/'
  end

  @contacts = display_filtered_contacts(filtered_obj) unless filtered_obj.empty?
  # Re-render since redirect clears instance variables
  erb(:home)
end

get '/:contact/edit' do
  contact_idx = params[:contact].to_i
  # Make values available for fields
  @contact_info = session[:contact_list].display_contacts[contact_idx][:details]
  erb(:contact)
end

post '/:contact/edit' do
  contact_idx = params[:contact].to_i
  @contact_info = session[:contact_list].display_contacts[contact_idx][:details]
  
  if valid_input?(params[:name], params[:phone_num], params[:address])
    # session[:contact_list].add_contact(params[:name], params[:phone_num], params[:address], @categories)

    session[:message] = "Contact for #{@contact_info[:name]} successfully updated."
    redirect '/'
  end
  
  status 422
  session[:message] = 'Invalid field detected! Please check and try again.'
  erb(:contact)
end
