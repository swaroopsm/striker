require 'RMagick'

module Striker
	module Media
		class Image < Site

			include Magick

			attr_reader :page, :image_options
			attr_accessor :url, :src

			def initialize(page, image_options={})
				@page = page
				@dir = File.join(@page.site_defaults.media_dir, "images", page.base_dir) if @page
				@image_options = image_options
			end

			# Returns all images of a page
			def all
				images = []
				entries.each do |i|
					if i.match(/\.(jpg|jpeg|bmp|gif|png|svg)$/i) and not i.match(/^thumbnail\.(jpg|jpeg|bmp|gif|png|svg)/i)
						page_image = File.join(@page.site_defaults.media_dir, "images", @page.base_dir, i)
						image = {
							'src' => i,
							'url' => File.join(@page.site_defaults.config['assets'], "images/#{@page.name}-#{i}"),
							'content_type' => mime_type(i)
						}
						if Dir.exists? File.join(@page.site_defaults.assets_dir, 'images')
							FileUtils.cp_r page_image, File.join(@page.site_defaults.assets_dir, 'images', "#{@page.name}-#{i}")
						end
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

					{ 
						'src' => new_image_name,
						'content_type' => mime_type(thumbnail[0]),
						'url' => File.join(@page.site_defaults.config['basepath'], @page.site_defaults.config['assets'], 'images',new_image_name)
					}
				end
			end

			def thumbnailize
				base_dir = File.join(@image_options[:site_defaults].media_dir, 'images', @image_options[:page]['base_dir'])
				src = @image_options[:page]['thumbnail']['src']
				image = ImageList.new(File.join(base_dir, "thumbnail#{File.extname src}")).first
				resized_image = self.process_resize(image)
				resized_image.write File.join(@image_options[:site_defaults].assets_dir, 'images', src)
			end

			def process_resize(image)
				if @image_options[:scale]
					image.resize!(@image_options[:scale].to_f)
				elsif @image_options[:width] and @image_options[:height]
					image.resize!(@image_options[:width].to_i, @image_options[:height].to_i)
				end
				image
			end

			## For gallery
			def self.gallerize(site_defaults)
				Dir.chdir site_defaults.gallery_dir
				main_width, main_height = site_defaults.config['gallerize']['main'].split("X")
				thumb_width, thumb_height = site_defaults.config['gallerize']['thumb'].split("X")
				Dir.glob("*").each_with_index do |file, counter|
					image = Magick::Image.read(file).first
					thumbnail = image.resize_to_fit thumb_width.to_i, thumb_height.to_i
					thumbnail.write(File.join(site_defaults.assets_dir, "images", "gallery-#{counter}-thumb-#{file}")) do 
						self.quality = 75
					end
					
					main = image.resize_to_fit main_width.to_i, main_height.to_i
					main.write(File.join(site_defaults.assets_dir, "images", "gallery-#{counter}-main-#{file}")) do
						self.quality = 60
					end
				end
			end

			def self.urlize(image)
				File.join(@page.site_defaults::BASEURL, @page.site_defaults.config['assets'], "images", image)
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
