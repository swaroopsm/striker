require 'RMagick'

module Striker
	module Media
		class Image

			include Magick

			attr_reader :page, :image_options
			attr_accessor :url, :src

			def initialize(page, image_options={})
				@page = page
				@dir = File.join(Settings::MEDIA_DIR, "images", page.base_dir) if @page
				@image_options = image_options
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
				if thumbnail.any?
					full_image = File.join(@dir, thumbnail[0])
					new_image_name = @page.name + File.extname(full_image)

					{ 'src' => new_image_name, 'content_type' => mime_type(thumbnail[0]), 'url' => File.join('/', Settings::CONFIG['assets'], 'images', new_image_name) }
				end
			end

			def thumbnailize
				base_dir = File.join(Settings::MEDIA_DIR, 'images', @image_options[:context]['base_dir'])
				src = @image_options[:context]['thumbnail']['src']
				image = ImageList.new(File.join(base_dir, "thumbnail#{File.extname src}")).first
				if @image_options[:scale]
					image.resize!(@image_options[:scale].to_f)
				elsif @image_options[:width] and @image_options[:height]
					image.resize!(@image_options[:width].to_i, @image_options[:height].to_i)
				end
				image.write File.join(Settings::ASSETS_DIR, 'images', src)
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
