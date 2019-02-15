# frozen_string_literal: true

module VueHelper
  def vue_component(name, props: {}, &block)
    block ||= -> {}
    props.transform_keys! { |key| key.to_s.underscore.tr('_', '-') }
    content_tag(name, props, &block)
  end
end
