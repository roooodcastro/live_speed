# frozen_string_literal: true

module AttributeValidator
  include ActiveSupport::Concern

  def validate
    model_class = controller_name.classify.constantize
    errors = model_class.validate_input(params[:column], params[:value])
    render json: { valid: errors.blank?, errors: errors }
  end
end
