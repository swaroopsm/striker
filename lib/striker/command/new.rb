module Striker
	module Command
		class New

			# Generates new site and related directories
			def self.process(args, options)
				site_name = args.join
				FileUtils.mkdir site_name
				FileUtils.cp_r Dir.glob(File.expand_path('../../../new_site', __FILE__) + '/*'), File.join(Dir.pwd, site_name)
				FileUtils.mkdir_p File.join(Settings::SOURCE_DIR, "media")
				FileUtils.mkdir_p File.join(Settings::SOURCE_DIR, "pages")
				FileUtils.mkdir_p File.join(Settings::MEDIA_DIR,  "images")
				FileUtils.mkdir_p File.join(Settings::SOURCE_DIR, "videos")
				FileUtils.mkdir_p File.join(Settings::SOURCE_DIR, "sounds")
			end

		end
	end
end
