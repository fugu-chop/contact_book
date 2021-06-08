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

get '/' do
  erb(:home)
end

get '/contact' do
  erb(:contact)
end
