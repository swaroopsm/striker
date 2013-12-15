module Striker
	class Settings

		# Default directory paths
		SOURCE_DIR     = Dir.pwd
		PAGES_DIR      = File.join(SOURCE_DIR, 'pages')
		TEMPLATES_DIR  = File.join(SOURCE_DIR, 'templates')
		MEDIA_DIR      = File.join(SOURCE_DIR, 'media')
		PLUGINS_DIR		 = File.join(SOURCE_DIR, 'plugins')

		# Templates path for new page generation
		PAGES_TEMPLATE  = File.expand_path(File.join('../command/templates'), __FILE__)

		# Default configuration from config.yml
		if File.exists? File.join SOURCE_DIR, 'config.yml'
			CONFIG = YAML.load_file(File.join(SOURCE_DIR, 'config.yml'))

			PUBLIC_DIR 		 = File.join(SOURCE_DIR, CONFIG['destination'])

			BASEPATH 			 = File.join(PUBLIC_DIR, CONFIG['basepath'])

			ASSETS_DIR	 	 = File.join(BASEPATH, CONFIG['assets'])

			BASEURL 			 = File.join(CONFIG['basepath'])

			if CONFIG['gallerize']
				GALLERY_DIR  = File.join(SOURCE_DIR, '_gallery')
			end
		end

	end
end
