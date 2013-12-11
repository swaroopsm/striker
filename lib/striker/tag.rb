module Striker
	class Tag
		
		attr_reader :tag

		def initialize(tag)
			@tag = tag
		end 

		def pages
			pages = []
			Dir.chdir(Settings::PAGES_DIR)
			Dir.glob("*[.md|.markdown]").each do |page|
				page = Page.new(page)
				pages << page.page_data if page.meta['tags'] and page.meta['tags'].include? tag
			end
			pages
		end

		def self.list
			tags = []
			Dir.chdir(Settings::PAGES_DIR)
			Dir.glob("*[.md|.markdown]").each do |file|
				page = Page.new(file)
				tags << page.meta['tags'] if page.meta['tags']
			end
			tags.flatten.uniq!
		end

		def self.list_full
			tags = []
			Dir.chdir(Settings::PAGES_DIR)
			pages = Dir.glob("*[.md|.markdown]").map{ |page| Page.new(page) }
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

		def self.process(site_meta)
			@@site_meta = site_meta
			self.list.each do |tag|
				FileUtils.mkdir_p(File.join(Settings::BASEPATH, Settings::CONFIG['tagged'], tag))
			end
			process_tags
		end

		def self.process_tags
			
			# Tag index template for tags
			index_template = File.open(File.join(Settings::TEMPLATES_DIR, "tags/index.html"), "r").read
			File.open(File.join(Settings::BASEPATH, Settings::CONFIG['tagged'], "index.html"), "w") do |f|
				f.write Liquid::Template.parse(index_template).render(
					'site' => @@site_meta
				)
			end

			# Process each tag
			template = File.open(File.join(Settings::TEMPLATES_DIR, "tags/tag.html"), "r").read
			Tag.list.each do |tag|
				File.open(File.join(Settings::BASEPATH, Settings::CONFIG['tagged'], tag, "index.html"), "w") do |f|
					f.write Liquid::Template.parse(template).render(
						'site' => @@site_meta,
						'pages' => Tag.new(tag).pages
					)
				end
			end
		end

		private_class_method :process_tags

	end
end
