module Striker

	class Template
		
		attr_reader :page

		def initialize(page, meta)
			@page = page
			@site_meta = meta
			@markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :tables => true)
		end

		def process
			template = File.open(File.join(@page.site_defaults.templates_dir, "#{@page.template}.html"), 'r').read
			File.open(File.join(@page.site_defaults.basepath, "#{@page.permalink}"), 'w') do |f|
				f.write Liquid::Template.parse(template).render(
					'content' => parsed_content(@page.content), 
					'page' => @page.page_data,
					'site' => @site_meta,
					'sections' => parse_sections
				)
			end
		end

		private
		def parsed_content(content)
			Liquid::Template.parse(@markdown.render(content)).render(
				'site' => @site_meta,
				'page' => @page.page_data
			)
		end

		def parse_sections
			sections = {}
			if @page.sections
				@page.sections.each do |section|
					sections[section['name']] = parsed_content(section['content'])
				end
			end
			sections
		end

	end
end
