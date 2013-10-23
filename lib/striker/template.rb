module Striker

	class Template
		
		attr_reader :page

		def initialize(page)
			@page = page
		end

		def process
			template = File.open(File.join(Settings::TEMPLATES_DIR, "page.html"), 'r').read
			markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true)
			File.open(File.join(Settings::PUBLIC_DIR, "#{@page.permalink}"), 'w') do |f|
				f.write Liquid::Template.parse(template).render(
					'content' => parsed_content(markdown), 
					'page' => @page.page_data,
					'site' => Site.meta
				)
			end
			process_tags if Settings::CONFIG['tagged']
		end

		private
		def parsed_content(markdown)
			Liquid::Template.parse(markdown.render(@page.content)).render(
				'site' => Site.meta,
				'page' => @page.page_data
			)
		end

		def process_tags
			Tag.process
			template = File.open(File.join(Settings::EXTRAS_DIR, "tag.html"), "r").read
			Tag.list.each do |tag|
				File.open(File.join(Settings::PUBLIC_DIR, Settings::CONFIG['tagged']['style'], tag, "index.html"), "w") do |f|
					f.write Liquid::Template.parse(template).render(
						'pages' => Tag.new(tag).pages
					)
				end
			end
		end

	end
end
