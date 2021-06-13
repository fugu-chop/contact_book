ENV["RACK_ENV"] = "test"

require 'minitest/autorun'
require 'rack/test'
require 'bcrypt'
require_relative '../lib/routes'
# require "#{File.expand_path('../../lib', __FILE__)}/.env"

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def session
    last_request.env['rack.session']
  end

  def admin_session
    { 'rack.session' => { login: 'success' } }
  end

  def test_index_logged_out
    get '/'

    assert_equal(302, last_response.status)
    assert_equal('You need to be logged in to do that.', session[:message])
  end

  def test_index_logged_in
    get "/", {}, { "rack.session" => { username: "admin" } }

    assert_equal(200, last_response.status)
    assert_equal('text/html;charset=utf-8', last_response['Content-Type'])
    refute_nil(session[:username])
    assert_includes(last_response.body, "Signed in as #{session[:username]}")
  end

  def test_login_page_view
    get '/users/login'

    assert_equal(200, last_response.status)
    assert_equal('text/html;charset=utf-8', last_response['Content-Type'])
    assert_includes(last_response.body, '<form')
    refute_includes(last_response.body, 'Signed in as')
  end

  def test_login_valid
    post '/users/login', { username: 'admin', password: 'secret' }

    assert_equal(302, last_response.status)
    assert_equal('success', session[:login])
  end

  def test_login_invalid
    post '/users/login', { username: 'random_string', password: 'some_pass' }

    assert_equal(422, last_response.status)
    # Can't access the session[:message] after re-render due to delete method
    assert_includes(last_response.body, "Incorrect login details; please try again")
  end

  def test_logout
    post '/users/logout'

    assert_equal(302, last_response.status)
    assert_equal(session[:message], "You have been logged out.")
    assert_nil(session[:username])
  end

  def test_create_new
    get '/new'

    assert_equal(200, last_response.status)
    assert_equal('text/html;charset=utf-8', last_response['Content-Type'])
    assert_includes(last_response.body, "<input name='phone_num'")
  end
end