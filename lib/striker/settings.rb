module Striker
	class Settings

		attr_reader :source, :pages_dir, :templates_dir, :media_dir, :plugins_dir, :pages_template,
								:config, :public_dir, :basepath, :assets_dir, :baseurl, :gallery_dir

		def initialize(source)
			
			# Default directory paths
			@source 				= source
			@pages_dir 			= File.join(@source, "pages")
			@templates_dir  = File.join(source, "templates")
			@media_dir      = File.join(source, "media")
			@plugins_dir		= File.join(source, "plugins")

			# Default configuration from config.yml
			if File.exists? File.join @source, 'config.yml'
				@config = YAML.load_file(File.join(@source, 'config.yml'))

				@public_dir 		 = File.join(@source, @config['destination'])

				@basepath 			 = File.join(@public_dir, @config['basepath'])

				@assets_dir	 	 = File.join(@basepath, @config['assets'])

				@baseurl 			 = File.join(@config['basepath'])

				if @config['gallerize']
					@gallery_dir  = File.join(@source, '_gallery')
				end
			end

		end

		# Default directory paths
		# SOURCE_DIR     = Dir.pwd
		# PAGES_DIR      = File.join(SOURCE_DIR, 'pages')
		# TEMPLATES_DIR  = File.join(SOURCE_DIR, 'templates')
		# MEDIA_DIR      = File.join(SOURCE_DIR, 'media')
		# PLUGINS_DIR		 = File.join(SOURCE_DIR, 'plugins')

		# # Templates path for new page generation
		PAGES_TEMPLATE  = File.expand_path(File.join('../command/templates'), __FILE__)

		# # Default configuration from config.yml
		# if File.exists? File.join SOURCE_DIR, 'config.yml'
		# 	CONFIG = YAML.load_file(File.join(SOURCE_DIR, 'config.yml'))

		# 	PUBLIC_DIR 		 = File.join(SOURCE_DIR, CONFIG['destination'])

		# 	BASEPATH 			 = File.join(PUBLIC_DIR, CONFIG['basepath'])

		# 	ASSETS_DIR	 	 = File.join(BASEPATH, CONFIG['assets'])

		# 	BASEURL 			 = File.join(CONFIG['basepath'])

		# 	if CONFIG['gallerize']
		# 		GALLERY_DIR  = File.join(SOURCE_DIR, '_gallery')
		# 	end
		# end

	end
end
