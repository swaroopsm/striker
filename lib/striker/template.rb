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
			Liquid::Template.parse(@file).render(
				'content' => @page.content, 
				'page' => @page.page_data,
				'site' => @site_meta,
				'sections' => parse_sections
			)
		end

		def liquidize
			Liquid::Template.parse(@markdown.render(@page.matter)).render(
				'site' => @site_meta,
				'page' => @page.page_data
			)
		end

		private
		def parsed_content(content)
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
