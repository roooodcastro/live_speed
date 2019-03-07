# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    render :landing_page unless player_logged_in?
  end
end
