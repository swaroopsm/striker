module Striker
	class Site

		def self.pages(ext=false)
			pages = []
			Dir.entries(Settings::PAGES_DIR).each do |page|
				unless page == '.' or page == '..'
					if ext
						pages << page 
					else
						pages << File.basename(page, File.extname(page))
					end
				end
			end
			pages
		end

		def self.meta
			data = Settings::CONFIG
			data['basepath'] = File.join "/", data['basepath']
			data['pages'] = Page.list_full
			data['tags'] = Tag.list_full if Settings::CONFIG['tagged']
			data['archive'] = Archive.list_full if Settings::CONFIG['archive']
			data
		end

	end
end
