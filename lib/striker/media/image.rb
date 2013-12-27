require "RMagick"

module Striker
	module Media
		class Image < Base
			
			attr_reader :image
			attr_accessor :label, :quality

			FORMATS = %w[.jpg .jpeg .bmp .gif .png .svg]
			THUMBNAIL_REGEX = /^thumbnail(#{FORMATS.join('|')})/

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
				@label = self.labelize(options)
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

			private
			def refactor(options={})
				@resized_image = options[:factor] ? 
												 @image.resize(options[:factor]) :
												 @image.resize_to_fit(options[:width], options[:height])
			end

			def make_move
				if @options[:sleep]
					FileUtils.cp_r(@image, File.join(self.settings.assets_dir, "images", @label))
				else
					if @resized_image
						quality = self.quality.to_i
						@resized_image.write(File.join(self.settings.assets_dir, "images", @label)) do
							self.quality = quality
						end
					end
				end
			end

			def process_gallery(options, postfix)
				size = options["size"].split("X")
				resize(size[0], size[1])
				self.quality = options["quality"] if options["quality"]
				move({ :prefix => "gal-1619", :postfix => postfix })
			end

		end
	end
end
