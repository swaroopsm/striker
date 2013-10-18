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
				f.write Liquid::Template.parse(template).render(
					'content' => parsed_content(markdown), 
					'page' => @page.meta,
					'site' => Settings::CONFIG
				)
			end
		end

		private
		def parsed_content(markdown)
			Liquid::Template.parse(markdown.render(@page.content)).render(
				'site' => Settings::CONFIG,
				'page' => {
					'meta' => @page.meta,
					'thumbnail' => @page.image.thumbnail,
					'name' => @page.name,
					'base_dir' => @page.base_dir
				 }
			)
		end

	end
end
