module Striker
	module Command
		class Server < Build

			def initialize(source, options)
				super(source)
				@options = options
			end

			def start
				if @options[:no_build]

				elsif @options[:build]
					self.process
				end

				start_server
			end

			private
			def start_server
				port = @settings.config['port']
				root = @settings.public_dir
				server = WEBrick::HTTPServer.new(:Port => port, :DocumentRoot => root)

				trap 'INT' do server.shutdown end
				p "Site running at: #{File.join("http://localhost:#{port}", @settings.config['basepath'])}"
				server.start
			end

		end
	end
end
