require "jim/engine"
require 'redcarpet'

module Jim
  def self.markdown_render(string)
    @renderer ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    @renderer.render(string || "").html_safe
  end
end
