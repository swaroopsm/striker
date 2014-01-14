module Striker

	class Template
		
		attr_reader :page, :name

		def initialize(page, site_meta)
			@page = page
			@site_meta = site_meta
			@markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :tables => true)
			@file = File.open(File.join(@page.settings.templates_dir, "#{@page.meta['template']}.html"), 'r').read
		end

		def process
			page_data = @page.page_data
			page_data['sections'] = parse_sections
			Liquid::Template.parse(@file).render(
				'content' => @page.content, 
				'page' => page_data,
				'site' => @site_meta
			)
		end

		def liquidize
			parsed_content(@page.matter)
		end

		private
		def parsed_content(content)
			Liquid::Template.parse(@markdown.render(content)).render(
				'site' => @site_meta,
				'page' => @page.page_data
			)
		end

		def parse_sections
			sections = []
			if @page.sections
				@page.sections.each do |section|
					sections << { 'name' => section['name'], 'content' => parsed_content(section['content']) }
				end
			end
			sections
		end

	end
end
