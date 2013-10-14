require 'redcarpet'
require 'liquid'

module Striker

	class Template
		
		attr_reader :page

		def initialize(page)
			@page = page
		end

		def process
			template = File.open(File.join(Settings::TEMPLATES_DIR, "page.html"), 'r').read
			markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true)
			File.open(File.join(Settings::PUBLIC_DIR, "#{@page.name}.html"), 'w') do |f|
				f.write Liquid::Template.parse(template).render 'content' => markdown.render(@page.content), 'page' => @page.meta
			end
		end

	end
end
