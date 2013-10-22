module Striker
	module Command
		class Build
			
			def self.process
				FileUtils.rm_rf(File.join Settings::PUBLIC_DIR, ".")
				FileUtils.mkdir_p(Settings::PUBLIC_DIR)
				FileUtils.mkdir_p(Settings::ASSETS_DIR)
				Settings::CONFIG['include_assets'].each do |d|
					FileUtils.cp_r(File.join(Settings::SOURCE_DIR, d), Settings::ASSETS_DIR) if File.exists? d
				end
				FileUtils.cp_r(File.join(Settings::SOURCE_DIR, "css"), File.join(Settings::ASSETS_DIR))
				Dir.glob(Settings::MEDIA_DIR + "/*").each do |d|
					FileUtils.mkdir_p File.join(Settings::ASSETS_DIR, d.split("/")[-1]) if File.directory? d
				end
				site = Site.new

				# Process Pages
				site.pages(true).each do |p|
					page = Striker::Page.new(p)
					t = Template.new(page)
					t.process
				end

				# Process Site Tags
				Tag.process if Settings::CONFIG['tagged']
			end

		end
	end
end
