module Striker
	class Settings

		# Default directory paths
		SOURCE_DIR     = Dir.pwd
		PAGES_DIR      = File.join(SOURCE_DIR, "pages")
		TEMPLATES_DIR  = File.join(SOURCE_DIR, "templates")
		MEDIA_DIR      = File.join(SOURCE_DIR, "media")
		PUBLIC_DIR 		 = File.join(SOURCE_DIR, "public")

	end
end
