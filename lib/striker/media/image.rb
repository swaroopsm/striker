module Striker
	module Media
		class Image
			
			attr_reader :page

			def initialize(page)
				@page = page
				@dir = File.join(Settings::MEDIA_DIR, "images", page.name)
			end

			# Returns all images of a page
			def all
				images = []
				if Dir.exists? @dir
					Dir.entries(@dir).each do |i|
						unless i == '.' or i == '..'
							images << i if i.match(/\.(jpg|jpeg|bmp|gif|png|svg)$/i)
						end
					end
				end
				images
			end

		end
	end
end
