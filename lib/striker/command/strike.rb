require 'webrick'

module Striker
	module Command
		class Strike

			def self.run(args, options)
				port = Settings::CONFIG['port']
				root = Settings::PUBLIC_DIR
				server = WEBrick::HTTPServer.new(:Port => port, :DocumentRoot => root)

				trap 'INT' do server.shutdown end
				p "Site running at: #{File.join("http://localhost:#{port}", Settings::CONFIG['basepath'])}"
				server.start
			end

		end
	end
end
