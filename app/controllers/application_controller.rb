# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery

  include PlayerLogin
  include UserLogin
end
