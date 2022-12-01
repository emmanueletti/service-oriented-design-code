# i guess the current file path is stored in a global constant __FILE__
require File.dirname(__FILE__) + "/../service"
require "spec"
require "spec/interop/test"
require "rack/test"

# boilder plate for using rspec on sinatra apps
set :environment, :test
Test::Unit::TestCase.send :include, Rack::Test::Methods

# boilder plate for using rspec on sinatra apps
def app
  Sinatra::Application
end

# describe is a way to namespace tests
describe "service" do
  before(:each) do
    User.delete_all
  end

  describe "GET on /api/v1/users/:id" do
    before(:each) do
      # factories and fixtures are an attempt to get away from having to setup
      # database records in a test db
      User.create(
        name: "emmanuel",
        email: "emmanuel@gmail.com",
        password: "strongpass",
        bio: "rubyist"
      )

      it "should return a user by name" do
        get "/api/v1/users/emmanuel"

        # is Rspec just a try-hard gem for making tests read like english? I
        # prefer the simplicity of minitest
        last_response.should be_ok
        attributes = JSON.parse(last_response.body)
        attributes["name"].should == "emmanuel"
      end

      it "should return a user with an email" do
        get "/api/v1/users/emmanuel"

        last_response.should be_ok
        attributes = JSON.parse(last_response.body)
        attributes["email"].should == "emmanuel@gmail.com"
      end

      it "should not return a users password" do
        get "/api/v1/users/emmanuel"

        last_response.should be_ok
        attributes = JSON.parse(last_response.body)
        attributes.should_not have_key("password")
      end

      it "should return a user with a bio" do
        get "/api/v1/users/emmanuel"

        last_response.should be_ok
        attributes = JSON.parse(last_response.body)
        attributes["bio"].should == "rubyist"
      end

      it "should return 404 for a user that does not exist" do
        get "/api/v1/users/does_not_exist"

        last_response.status.should == 404
      end
    end
  end
end
