module Striker
	module Command
		class Build
			
			def self.process

				@@meta = Site.meta

				init_dir

				process_pages

				process_tags

				process_archive

			end

			# Create initial site directories
			def self.init_dir
				FileUtils.rm_rf(File.join Settings::PUBLIC_DIR, ".")
				FileUtils.mkdir_p [ Settings::PUBLIC_DIR, Settings::ASSETS_DIR, Settings::BASEPATH ]
				Settings::CONFIG['include_assets'].each do |d|
					FileUtils.cp_r(File.join(Settings::SOURCE_DIR, d), Settings::ASSETS_DIR) if File.exists? d
				end
				FileUtils.cp_r(File.join(Settings::SOURCE_DIR, "css"), File.join(Settings::ASSETS_DIR))
				Dir.glob(Settings::MEDIA_DIR + "/*").each do |d|
					FileUtils.mkdir_p File.join(Settings::ASSETS_DIR, d.split("/")[-1]) if File.directory? d
				end
			end

			# Process and convert pages to html
			def self.process_pages
				Site.pages(true).each do |p|
					page = Striker::Page.new(p)
					t = Template.new(page, @@meta)
					t.process
				end
			end

			# Process page tags
			def self.process_tags
				Tag.process(@@meta) if Settings::CONFIG['tagged']
			end

			# Process site archive
			def self.process_archive
				Archive.process(@@meta) if Settings::CONFIG['archive']
			end

			private_class_method :init_dir, :process_pages, :process_tags, :process_archive

		end
	end
end
