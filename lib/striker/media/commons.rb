module Striker
	module Media
		module Commons

			def media_type(type)
				@data = []
				Dir.chdir(File.join(self.settings.assets_dir, type))
				case type
				when "images"
					@regex = /^#{self.base_dir}-([\w\d\-@#\$]*)(.jpg|.jpeg|.bmp|.gif|.png|.svg)/
				end
				Dir.glob("*").each do |i|
					if i.match @regex
						image = Media::Base.new(i)
						image.referrer = "images"
						@data << image.result
					end
				end
				@data
			end

			def move_media(type)
				Dir.chdir(File.join(self.settings.media_dir, type, self.base_dir))
				Dir.glob("*").each do |i|
					if type == "images"
						image = Media::Image.new(i, { :sleep => true })
						image.move({ :prefix => self.base_dir }) unless image.thumbnail?
					end
				end
			end

			def has_media?(type)
				Dir.glob(File.join(self.settings.media_dir, type, "*")).reject{
					|i| i.match /#{Image::THUMBNAIL_REGEX}/ 
				}.size > 0
			end

			def find(file, formats, options={})
				Dir.chdir(options[:path]) if options[:path]
				Dir.glob("*{#{formats.join(',')}}").each do |f|
					@file = f if f.match /^#{file}(#{formats.join("|")})/
				end
				@file ? yield(@file) : return
			end

		end
	end
end
