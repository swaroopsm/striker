module Striker
	class Tag
		
		def self.list
			@@tags = []
			Dir.chdir(Settings::PAGES_DIR)
			Dir.glob("*[.md|markdown]").each do |file|
				page = Page.new(file)
				@@tags << page.meta['tags'] if page.meta['tags']
			end
			@@tags = @@tags.flatten.uniq!
			create_tag_files
			@@tags
		end

		def self.create_tag_files
			@@tags.each do |tag|
				FileUtils.mkdir_p(File.join(Settings::PUBLIC_DIR, Settings::CONFIG['tags'], tag))
			end
		end

		private_class_method :create_tag_files

	end
end
