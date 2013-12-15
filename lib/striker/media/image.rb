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
						page_image = File.join(Settings::MEDIA_DIR, "images", @page.base_dir, i)
						image = {
							'src' => i,
							'url' => File.join(Settings::CONFIG['basepath'], Settings::CONFIG['assets'], "images/#{@page.name}-#{i}"),
							'content_type' => mime_type(i)
						}
						if Dir.exists? File.join(Settings::ASSETS_DIR, 'images')
							FileUtils.cp_r page_image, File.join(Settings::ASSETS_DIR, 'images', "#{@page.name}-#{i}")
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
						'url' => File.join(Settings::CONFIG['basepath'], Settings::CONFIG['assets'], 'images',new_image_name)
					}
				end
			end

			def thumbnailize
				base_dir = File.join(Settings::MEDIA_DIR, 'images', @image_options[:context]['base_dir'])
				src = @image_options[:context]['thumbnail']['src']
				image = ImageList.new(File.join(base_dir, "thumbnail#{File.extname src}")).first
				resized_image = self.process_resize(image)
				resized_image.write File.join(Settings::ASSETS_DIR, 'images', src)
			end

			def process_resize(image)
				if @image_options[:scale]
					image.resize!(@image_options[:scale].to_f)
				elsif @image_options[:width] and @image_options[:height]
					image.resize!(@image_options[:width].to_i, @image_options[:height].to_i)
				end
				image
			end

			# Processes Site Logo
			def self.process_logo
				logo = nil
				FileUtils.chdir File.join(Settings::MEDIA_DIR, "images")
				Dir.glob("*.{jpg,jpeg,bmp,gif,png,svg}").each do |i|
					if i.match(/^logo.(jpg|jpeg|bmp|gif|png|svg)/)
						logo = "logo." + $1
						break
					end
				end
				if logo
					FileUtils.cp(logo, File.join(Settings::ASSETS_DIR, "images"))
	 				File.join Settings::BASEURL, Settings::CONFIG['assets'], "images", logo
				else
					logo
				end
			end

			## For gallery
			def self.gallerize
				Dir.chdir Settings::GALLERY_DIR
				main_width, main_height = Settings::CONFIG['gallery']['main'].split("X")
				thumb_width, thumb_height = Settings::CONFIG['gallery']['thumb'].split("X")
				Dir.glob("*").each_with_index do |file, counter|
					image = Magick::Image.read(file).first
					thumbnail = image.resize_to_fit thumb_width.to_i, thumb_height.to_i
					thumbnail.write(File.join(Settings::ASSETS_DIR, "images", "gallery-#{counter}-thumb-#{file}")) do 
						self.quality = 75
					end
					
					main = image.resize_to_fit main_width.to_i, main_height.to_i
					main.write(File.join(Settings::ASSETS_DIR, "images", "gallery-#{counter}-main-#{file}")) do
						self.quality = 60
					end
				end
			end

			def self.gallery
				images = []
				Dir.chdir File.join(Settings::ASSETS_DIR, "images")
				thumb_re = /^gallery-thumb-/
				main_re = /^gallery-main-/
				Dir.glob("gallery-*").each do |g|
					thumb = g if g.match(thumb_re)
					main = g if g.match(main_re)
					images << { 'thumbnail' => thumb, 'main' => main }
				end
				images
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
