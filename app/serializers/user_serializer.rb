# frozen_string_literal: true

class UserSerializer < ApplicationSerializer
  include Rails.application.routes.url_helpers

  def as_json
    {
      id:           record.id,
      name:         record.name,
      email:        record.email,
      edit_path:    edit_user_path(record.id),
      destroy_path: user_path(record.id)
    }
  end
end
