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
				@image = options[:sleep] ? resource : Magick::Image.read(resource).first
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

			private
			def refactor(options={})
				if options[:factor]
					@image.resize!(options[:factor])
				else
					@image.resize!(options[:width], options[:height])
				end
			end

			def make_move
				if @options[:sleep]
					FileUtils.cp_r(@image, File.join(self.settings.assets_dir, "images", @label))
				else
					quality = self.quality.to_i
					@image.write(File.join(self.settings.assets_dir, "images", @label)) do
						self.quality = quality
					end
				end
			end

		end
	end
end
