# frozen_string_literal: true

module MainMenu
  extend ActiveSupport::Concern

  included do
    helper_method :build_menu_bar
  end

  protected

  def build_menu_bar
    menu_file = player_logged_in? ? 'user_menu.yml' : 'guest_menu.yml'
    menu_file_path = Rails.root.join('app', 'views', 'layouts', menu_file)
    @build_menu_bar ||= YAML.safe_load(ERB.new(File.read(menu_file_path)).result(binding))
  end
end
