module Striker
	module Command
		class Build
			
			def self.process
				FileUtils.mkdir_p(Settings::PUBLIC_DIR)
			end

		end
	end
end
