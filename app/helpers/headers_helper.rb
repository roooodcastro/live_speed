# frozen_string_literal: true

module HeadersHelper
  def title(title)
    content_for(:title) { [title, t(:title)].join(' - ') }
    content_tag(:h1, title)
  end

  def anchored_header(title, opts = {})
    header_tag = opts.fetch(:tag, :h2)
    id = opts.fetch(:id, CGI.escape(title.parameterize))
    content_tag(header_tag, id: id) do
      concat link_to ']', "##{id}", class: 'header-anchor'
      concat title
    end
  end
end
