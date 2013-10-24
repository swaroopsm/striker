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
			File.open(File.join(Settings::PUBLIC_DIR, "#{@page.permalink}"), 'w') do |f|
				f.write Liquid::Template.parse(template).render(
					'content' => parsed_content(markdown), 
					'page' => @page.page_data,
					'site' => @site_meta
				)
			end
			process_tags if Settings::CONFIG['tagged']
		end

		private
		def parsed_content(markdown)
			Liquid::Template.parse(markdown.render(@page.content)).render(
				'site' => @site_meta,
				'page' => @page.page_data
			)
		end

		def process_tags
			Tag.process
			
			# Tag index template for tags
			index_template = File.open(File.join(Settings::TEMPLATES_DIR, "tags/index.html"), "r").read
			File.open(File.join(Settings::PUBLIC_DIR, Settings::CONFIG['tagged']['style'], "index.html"), "w") do |f|
				f.write Liquid::Template.parse(index_template).render(
					'site' => @site_meta
				)
			end

			# Process each tag
			template = File.open(File.join(Settings::TEMPLATES_DIR, "tags/tag.html"), "r").read
			Tag.list.each do |tag|
				File.open(File.join(Settings::PUBLIC_DIR, Settings::CONFIG['tagged']['style'], tag, "index.html"), "w") do |f|
					f.write Liquid::Template.parse(template).render(
						'site' => @site_meta,
						'pages' => Tag.new(tag).pages
					)
				end
			end
		end

	end
end
