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

				init_dir

				@site = Site.new(@settings)
				@site_defaults = @site.site_defaults

				process_for_site

				process_pages

				process_tags

				# process_archive

			end

			def serve
				port = @settings.config['port']
				root = @settings.public_dir
				server = WEBrick::HTTPServer.new(:Port => port, :DocumentRoot => root)

				trap 'INT' do server.shutdown end
				p "Site running at: #{File.join("http://localhost:#{port}", @settings.config['basepath'])}"
				server.start
				
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
				Dir.glob(@settings::media_dir + "/*").each do |d|
					FileUtils.mkdir_p File.join(@settings.assets_dir, d.split("/")[-1]) if File.directory? d
				end
				if @settings.config['include']
					@settings::config['include'].each do |file|
						FileUtils.cp_r(File.join(@settings.source, file), @settings.basepath)
					end
				end
			end

			# Process and convert pages to html
			def process_pages
				@site.pages(true).each do |p|
					page = Striker::Page.new(p, { :site_defaults => @site_defaults })
					t = Template.new(page, @site_defaults)
					t.process
				end
			end

			# Process page tags
			def process_tags
				Tag.process(@site_defaults) if @settings.config['tagged']
			end

			# Process site archive
			def process_archive
				Archive.new(@settings).process(@@meta) if @settings::config['archive']
			end

			# Process info needed for site meta
			def process_for_site
				@site_meta = @site.meta
				# Media::Image.gallerize if @settings.config['gallerize']
			end

			# private_class_method :init_dir, :process_pages, :process_tags, :process_archive, :process_for_site

		end
	end
end
