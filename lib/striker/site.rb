module Striker
	class Site

		attr_reader :name

		def initialize
			@name = Settings::CONFIG['name']
		end

		def pages(ext=false)
			pages = []
			Dir.entries(Settings::PAGES_DIR).each do |page|
				unless page == '.' or page == '..'
					unless ext
						pages << page 
					else
						pages << File.basename(page, File.extname(page))
					end
				end
			end
			pages
		end

	end
end
