module Striker
	class Settings

		# Default directory paths
		SOURCE_DIR     = Dir.pwd
		PAGES_DIR      = File.join(SOURCE_DIR, 'pages')
		TEMPLATES_DIR  = File.join(SOURCE_DIR, 'templates')
		MEDIA_DIR      = File.join(SOURCE_DIR, 'media')
		PUBLIC_DIR 		 = File.join(SOURCE_DIR, 'public')

		# Templates path for new page generation
		PAGES_TEMPLATE  = File.expand_path(File.join('../command/templates'), __FILE__)

		# Default configuration from config.yml
		CONFIG = YAML.load_file(File.join(SOURCE_DIR, 'config.yml'))

		ASSETS_DIR		 = File.join(PUBLIC_DIR, CONFIG['assets'])

	end
end
