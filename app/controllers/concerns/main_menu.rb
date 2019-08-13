# frozen_string_literal: true

module MainMenu
  extend ActiveSupport::Concern

  included do
    def self.build_menu(opts = {})
      before_action :build_menu, opts
    end
  end

  GUEST_MENU = {
    left:  [
      { href: how_to_play_path, label: 'How to Play' }
    ],
    right: [
      { href: new_sessions_path, label: 'Sign in' }
    ]
  }.freeze

  USER_MENU = {
    left:  [
      { href: lobby_path, label: 'Find a Match' },
      { href: matches_path, label: 'My Matches' },
      { href: how_to_play_path, label: 'How to Play' }
    ],
    right: [
      { href: sessions_path, method: :delete, label: 'Sign out' }
    ]
  }.freeze

  protected

  def build_menu
    @menu = (player_logged_in? ? USER_MENU : GUEST_MENU).as_json
  end
end
