module Striker
	module Command
		class Server < Build

			def initialize(args, options, path)
				super(args, options, path)
			end

			def start
				if self.options[:no_build]

				elsif self.options[:build]
					self.process
				end

				start_server
			end

			private
			def start_server
				port = self.config['port']
				root = self.public_dir
				server = WEBrick::HTTPServer.new(:Port => port, :DocumentRoot => root)

				trap 'INT' do server.shutdown end
				p "Site running at: #{File.join("http://localhost:#{port}", self.config['basepath'])}"
				server.start
			end

		end
	end
end
