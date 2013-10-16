module Striker
	module Media
		class Image
			
			attr_reader :page
			attr_accessor :url, :src

			def initialize(page)
				@page = page
				@dir = File.join(Settings::MEDIA_DIR, "images", page.name)
			end

			# Returns all images of a page
			def all
				images = []
				entries.each do |i|
					if i.match(/\.(jpg|jpeg|bmp|gif|png|svg)$/i) and not i.match(/^thumbnail\.(jpg|jpeg|bmp|gif|png|svg)/i)
						image = {
							'src' => i,
							'url' => nil,
							'content_type' => mime_type(i)
						}
						images << image
					end
				end
				images
			end

			def thumbnail
				thumbnail = []
				entries.each do |e|
				 thumbnail << e if e.match(/^thumbnail\.(jpg|jpeg|bmp|gif|png|svg)/i)
				end
				thumbnail.any? ? { 'src' => thumbnail[0], 'content_type' => mime_type(thumbnail[0]), 'url' => nil } : nil
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

			def mime_type(image)
				MIME::Types.type_for(File.extname(image))[0].content_type
			end

		end
	end
end
