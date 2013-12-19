module Striker
	class Tag
		
		attr_reader :tag

		def initialize(tag, options={})
			@tag = tag
			@site_defaults = options[:site_defaults]
		end 

		def pages
			pages = []
			Dir.chdir(@site_defaults.pages_dir)
			Dir.glob("*[.md|.markdown]").each do |page|
				page = Page.new(page, { :site_defaults => @site_defaults })
				pages << page.page_data if page.meta['tags'] and page.meta['tags'].include? tag
			end
			pages
		end

		def self.list
			tags = []
			Dir.chdir(@@site_defaults.pages_dir)
			Dir.glob("*[.md|.markdown]").each do |file|
				page = Page.new(file, { :site_defaults => @@site_defaults })
				tags << page.meta['tags'] if page.meta['tags']
			end
			tags.size > 0 ? tags.flatten.uniq! : tags
		end

		def self.list_full(site_defaults)
			@@site_defaults = site_defaults
			tags = []
			Dir.chdir(site_defaults.pages_dir)
			pages = Dir.glob("*[.md|.markdown]").map{ |page| Page.new(page, { :site_defaults => @@site_defaults }) }
			if self.list
				self.list.each do |tag|
					tagged = []
					pages.each do |page|
						tagged << page.page_data if page.meta['tags'] and page.meta['tags'].include? tag
					end
					tags << { 'name' => tag, 'pages' => tagged }
				end
			end
			tags
		end

		def self.process(site_defaults)
			@@site_defaults = site_defaults
			self.list.each do |tag|
				FileUtils.mkdir_p(File.join(@@site_defaults.basepath, @@site_defaults.config['tagged'], tag))
			end
			process_tags
		end

		def self.process_tags
			
			# Tag index template for tags
			index_template = File.open(File.join(@@site_defaults.templates_dir, "tags/index.html"), "r").read
			File.open(File.join(@@site_defaults.basepath, @@site_defaults.config['tagged'], "index.html"), "w") do |f|
				f.write Liquid::Template.parse(index_template).render(
					'site' => @@site_defaults
				)
			end

			# Process each tag
			template = File.open(File.join(@@site_defaults.templates_dir, "tags/tag.html"), "r").read
			Tag.list.each do |tag|
				File.open(File.join(@@site_defaults.basepath, @@site_defaults.config['tagged'], tag, "index.html"), "w") do |f|
					f.write Liquid::Template.parse(template).render(
						'site' => @@site_defaults,
						'pages' => Tag.new(tag, { :site_defaults => @@site_defaults }).pages
					)
				end
			end
		end

		private_class_method :process_tags

	end
end
