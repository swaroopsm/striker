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
				entries.each do |i|
					images << i if i.match(/\.(jpg|jpeg|bmp|gif|png|svg)$/i)
				end
				images
			end

			def thumbnail
				thumbnail = []
				entries.each do |e|
				 thumbnail << e if e.match(/^thumbnail\.(jpg|jpeg|bmp|gif|png|svg)/i)
				end
				thumbnail.any? ? thumbnail[0] : nil
			end

			private
			def entries
				entries = []
				if Dir.exists? @dir
					Dir.entries(@dir).each do |e|
						entries << e unless e == '.' or e == '..'
					end
				end
				entries
			end

		end
	end
end
