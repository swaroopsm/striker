module Striker
	class Tag
		
		def self.list
			tags = []
			Dir.chdir(Settings::PAGES_DIR)
			Dir.glob("*[.md|.markdown]").each do |file|
				page = Page.new(file)
				tags << page.meta['tags'] if page.meta['tags']
			end
			tags.flatten.uniq!
		end

		def self.process
			self.list.each do |tag|
				FileUtils.mkdir_p(File.join(Settings::PUBLIC_DIR, Settings::CONFIG['tagged']['style'], tag))
			end
		end

	end
end
