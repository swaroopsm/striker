module Striker
	module Command
		class Sync < Settings
		
			def initialize(source, options)
				super(source)
				@options = options
				@remote = self.config['remote']
			end

			def process
				@remote_path = File.join("~", @remote["path"])
				@output = `rsync -avhP #{self.public_dir}/* #{@remote['username']}@#{@remote['host']}:#{@remote_path}`

				print "\n" + "---"*10 + "\n"
				@output.split("\n").reject{ |o| o.strip.empty?  }.each{ |o| print o + "\n" }
				print "---"*10 + "\n\n"
			end

		end
	end
end
