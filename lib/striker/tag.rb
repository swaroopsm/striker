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

		def self.list_full
			tags = []
			pages = []
			Dir.chdir(Settings::PAGES_DIR)
			pages = Dir.glob("*[.md|.markdown]").map{ |page| Page.new(page) }
			self.list.each do |tag|
				tagged = []
				pages.each do |page|
					tagged << page.page_data if page.meta['tags'] and page.meta['tags'].include? tag
				end
				tags << { 'name' => tag, 'pages' => tagged }
			end
			tags
		end

		def self.process
			self.list.each do |tag|
				FileUtils.mkdir_p(File.join(Settings::PUBLIC_DIR, Settings::CONFIG['tagged']['style'], tag))
			end
		end

	end
end
