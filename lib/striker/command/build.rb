module Striker
	module Command
		class Build
			
			def self.process
				FileUtils.mkdir_p(Settings::PUBLIC_DIR)
				site = Site.new
				site.pages(true).each do |p|
					page = Striker::Page.new(p)
					t = Template.new(page)
					t.process
				end
			end

		end
	end
end
