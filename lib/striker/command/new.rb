module Striker
	module Command
		class New

			# Generates new site and related directories
			def self.process(args, options)
				site_name = args.join
				FileUtils.mkdir site_name
				FileUtils.cp_r Dir.glob(File.expand_path('../../../new_site', __FILE__) + '/*'), File.join(Dir.pwd, site_name)
			end

		end
	end
end
