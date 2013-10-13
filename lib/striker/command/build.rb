module Striker
	module Command
		class Build
			
			def self.process
				FileUtils.mkdir(Settings::PUBLIC_DIR)
			end

		end
	end
end
