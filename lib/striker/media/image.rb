require "RMagick"

module Striker
	module Media
		class Image < Base
			
			attr_reader :image
			attr_accessor :label, :quality

			FORMATS = %w[.jpg .jpeg .bmp .gif .png .svg]
			THUMBNAIL_REGEX = /^thumbnail(#{FORMATS.join('|')})/
			GALLERY_PREFIX = "gal-1619"

			def initialize(resource, options={})
				super(resource)
				@options = options
				if options[:sleep]
					@image = resource
				else
					@image = options[:blob] ? Magick::Image.from_blob(options[:blob].read) : Magick::Image.read(resource)
				end
				@image = options[:sleep] ? resource : @image.first
				@quality = 100
			end
			
			def resize(width, height)
				refactor({ 
					:width => width.to_i,
					:height => height.to_i 
				})
			end

			def rescale(factor)
				refactor({
					:factor => factor.to_f 
				})
			end

			def thumbnailize(options={})
				refactor(options)
				self.move(options)
			end

			def move(options={})
				@label = self.labelize(options) unless @label
				make_move
			end

			def urlize
				File.join(
					self.settings.baseurl,
					self.settings.config['assets'],
					self.referrer,
					self.label
				)
			end

			def thumbnail?
				self.resource.match(/^thumbnail#{FORMATS.join("|")}$/)
			end

			def gallerize

				process_gallery(self.settings.config["gallerize"]["thumbnail"], "thumb")
				process_gallery(self.settings.config["gallerize"]["main"], "main")

			end

			def gallerized?
				Dir.chdir(File.join("/", "tmp", "_gallery"))
				if find(@label.basename, Media::Image::FORMATS)
					true
				else
					false
				end
			end

			private
			def refactor(options={})
				@resized_image = options[:factor] ? 
												 @image.resize(options[:factor]) :
												 @image.resize_to_fit(options[:width], options[:height])
			end

			def make_move
				path = @options[:gallery] ? "_gallery" : ""
				if @options[:sleep]
					FileUtils.cp_r(@image, File.join(self.settings.assets_dir, "images", path, @label))
				else
					if @resized_image
						quality = self.quality.to_i
						@resized_image.write(File.join(self.settings.assets_dir, "images", path, @label)) do
							self.quality = quality
						end
					end
				end
			end

			def process_gallery(options, postfix)
				@label = self.labelize({ :postfix => postfix })
				if gallerized?
					find(@label.basename, Media::Image::FORMATS) do |f|
						FileUtils.cp_r(f, File.join(self.settings.assets_dir, "images", "_gallery"))
					end
				else
					@options[:gallery] = true
					size = options["size"].split("X")
					resize(size[0], size[1])
					self.quality = options["quality"] if options["quality"]
					move
				end
			end

		end
	end
end
