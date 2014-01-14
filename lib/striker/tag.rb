module Striker
	class Tag < Site
		
		attr_reader :tag

		def initialize(tag=nil, options={})
			@tag = tag
			@settings = self.settings
			@options = options
		end 

		def pages
			pages = []
			Dir.chdir(@settings.pages_dir)
			Dir.glob("*[.md|.markdown]").each do |page|
				page = Page.new(page, { :site_meta => @options[:site_meta] })
				pages << page.page_data if page.meta['tagged'] and page.meta['tagged'].include? tag
			end
			pages
		end

		def list
			tags = []
			Dir.chdir(@settings.pages_dir)
			Dir.glob("*[.md|.markdown]").each do |file|
				page = Page.new(file, { :site_meta => @options[:site_meta] })
				tags << page.meta['tagged'] if page.meta['tagged']
			end
			tags.size > 0 ? tags.flatten.uniq : tags
		end

		def list_full
			tags = []
			Dir.chdir(self.settings.pages_dir)
			pages = Dir.glob("*[.md|.markdown]").map{ |page| Page.new(page) }
			if self.list
				self.list.each do |tag|
					tagged = []
					pages.each do |page|
						tagged << page.page_data if page.meta['tagged'] and page.meta['tagged'].include? tag
					end
					tags << { 'name' => tag, 'url' => File.join("/", @settings.baseurl, @settings.config['tagged'], tag), 'pages' => tagged }
				end
			end
			tags
		end

		def process
			self.list.each do |tag|
				FileUtils.mkdir_p(File.join(@settings.basepath, @settings.config['tagged'], tag))
			end
			process_tags
		end

		private
		def process_tags
			
			# Tag index template for tags
			index_template = File.open(File.join(@settings.templates_dir, "tags/index.html"), "r").read
			File.open(File.join(@settings.basepath, @settings.config['tagged'], "index.html"), "w") do |f|
				f.write Liquid::Template.parse(index_template).render(
					'site' => @options[:site_meta]
				)
			end

			# Process each tag
			template = File.open(File.join(@settings.templates_dir, "tags/tag.html"), "r").read
			self.list.each do |tag|
				File.open(File.join(@settings.basepath, @settings.config['tagged'], tag, "index.html"), "w") do |f|
					f.write Liquid::Template.parse(template).render(
						'site' => @options[:site_meta],
						'pages' => Tag.new(tag).pages
					)
				end
			end
		end

	end
end
