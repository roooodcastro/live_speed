# frozen_string_literal: true

module VueHelper
  def vue_component(name, props: {}, &block)
    block ||= -> {}
    props.transform_keys! { |key| key.to_s.underscore.tr('_', '-') }
    content_tag(name, props, &block)
  end

  def vue_flash(float: false)
    flashes = flash.map do |type, value|
      title = value.is_a?(Array) ? value[0] : nil
      content = value.is_a?(Array) ? value[1] : value
      { type: type, title: title, content: content }
    end

    vue_component('alerts-container', props: { ':alerts': flashes.to_json, ':float': float })
  end
end
