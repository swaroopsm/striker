module Striker
	class Site

		attr_accessor :pages

		def initialize
			@pages = []
			Dir.entries(Settings::PAGES_DIR).each do |page|
				@pages << File.basename(page, File.extname(page)) unless page == '.' or page == '..'
			end
			self.pages = @pages
		end

	end
end
