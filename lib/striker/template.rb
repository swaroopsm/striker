module Striker

	class Template
		
		attr_reader :page

		def initialize(page, meta)
			@page = page
			@site_meta = meta
		end

		def process
			template = File.open(File.join(Settings::TEMPLATES_DIR, "#{@page.template}.html"), 'r').read
			markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true)
			File.open(File.join(Settings::BASEPATH, "#{@page.permalink}"), 'w') do |f|
				f.write Liquid::Template.parse(template).render(
					'content' => parsed_content(markdown), 
					'page' => @page.page_data,
					'site' => @site_meta
				)
			end
		end

		private
		def parsed_content(markdown)
			Liquid::Template.parse(markdown.render(@page.content)).render(
				'site' => @site_meta,
				'page' => @page.page_data
			)
		end

	end
end
