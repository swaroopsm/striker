require "webrick"

module Striker
	module Command
		class Build

			attr_accessor :site_meta

			def initialize(source)
				@settings = Striker::Settings.new(source)

				Striker.configure(@settings)
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
				FileUtils.rm_rf(File.join @settings.public_dir, ".")

				FileUtils.mkdir_p [ @settings.basepath, @settings.assets_dir ]
				@settings.config['include_assets'].each do |d|
					FileUtils.cp_r(File.join(@settings.source, d), @settings.assets_dir)
				end

				FileUtils.cp_r(File.join(@settings.source, "css"), File.join(@settings.assets_dir))
				Dir.glob(@settings.media_dir + "/*").each do |d|
					FileUtils.mkdir_p File.join(@settings.assets_dir, d.split("/")[-1]) if File.directory? d
				end

				Dir.glob(@settings.media_dir + "/images/*" + "{#{Media::Image::FORMATS.join(',')}}").each do |i|
					if File.file? i
						image = Media::Image.new(i, { :sleep => true })
						image.move({ :prefix => "site-1619" })
					end
				end

				if @settings.config['include']
					@settings.config['include'].each do |file|
						FileUtils.cp_r(File.join(@settings.source, file), @settings.basepath)
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
				Tag.new(nil, {:site_meta => @meta}).process if @settings.config['tagged']
			end

			# Process site archive
			def process_archive
				# Archive.new.process if @settings.config['archive']
			end

			# Process info needed for site meta
			def process_for_site
				if @settings.config['gallerize']
					@site.gallerize
				end
				@site.process_logo
				@site_meta = @site.meta
			end

			def site_pre_process
				if Dir.exists? @settings.assets_dir + "/images"
					Dir.chdir(@settings.assets_dir + "/images")
					FileUtils.cp_r("_gallery", "/tmp") if Dir.exists?("_gallery")
				end
			end

		end
	end
end
