require "webrick"

module Striker
	module Command
		class Build < Base

			attr_accessor :site_meta

			def initialize(args, options, path)
				super(args, options, path)
				# self = Striker::Settings.new(source)

				# Striker.configure(self)
			end
			
			def process

				# begin

					site_pre_process

					init_dir

					@site = Site.new

					process_for_site

					@meta = @site.meta


					process_pages

					process_tags
 
					# process_archive

					true
				# rescue Exception => e
				# 	p e
				# end

			end

			private

			# Create initial site directories
			def init_dir
				FileUtils.rm_rf(File.join self.public_dir, ".")

				FileUtils.mkdir_p [ self.basepath, self.assets_dir ]
				self.config['include_assets'].each do |d|
					FileUtils.cp_r(File.join(self.source, d), self.assets_dir)
				end

				FileUtils.cp_r(File.join(self.source, "css"), File.join(self.assets_dir))
				Dir.glob(self.media_dir + "/*").each do |d|
					FileUtils.mkdir_p File.join(self.assets_dir, d.split("/")[-1]) if File.directory? d
				end

				Dir.glob(self.media_dir + "/images/*" + "{#{Media::Image::FORMATS.join(',')}}").each do |i|
					if File.file? i
						image = Media::Image.new(i, { :sleep => true })
						image.move({ :prefix => "site-1619" })
					end
				end

				FileUtils.cp_r(Dir.glob(File.join(self.extras_dir) + "/*"), File.join(self.basepath))

				if self.config['include']
					self.config['include'].each do |file|
						FileUtils.cp_r(File.join(self.source, file), self.basepath)
					end
				end
			end

			# Process and convert pages to html
			def process_pages
				@site.page_files(true).each do |p|
					page = Striker::Page.new(p, { :site_meta => @meta })
					# t = Template.new(page)
					page.process
				end
			end

			# Process page tags
			def process_tags
				Tag.new(nil, {:site_meta => @meta}).process if self.config['tagged']
			end

			# Process site archive
			def process_archive
				# Archive.new.process if self.config['archive']
			end

			# Process info needed for site meta
			def process_for_site
				if self.config['gallerize']
					@site.gallerize
				end
				@site.process_logo
				@site_meta = @site.meta
			end

			def site_pre_process
				if Dir.exists? self.assets_dir + "/images"
					Dir.chdir(self.assets_dir + "/images")
					FileUtils.cp_r("_gallery", "/tmp") if Dir.exists?("_gallery")
				end
			end

		end
	end
end
