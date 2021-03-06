module Striker
	class Settings

		attr_reader :source, :pages_dir, :templates_dir, :media_dir, :plugins_dir, :pages_template,
								:config, :public_dir, :basepath, :assets_dir, :baseurl, :gallery_dir, :server,
								:extras_dir

		def initialize(source)
			
			# Default directory paths
			@source 				= source
			@pages_dir 			= File.join(@source, "pages")
			@templates_dir  = File.join(source, "templates")
			@media_dir      = File.join(source, "media")
			@plugins_dir		= File.join(source, "plugins")
			@extras_dir 		= File.join(source, "extras")

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

			# Remote Server configuration
			if File.exists? File.join(@source, 'server.yml')
				@server = YAML.load_file(File.join(@source, 'server.yml'))
			end

		end

	  # Templates path for new page generation
		PAGES_TEMPLATE  = File.expand_path(File.join('../command/templates'), __FILE__)

	end
end
