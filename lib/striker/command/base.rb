module Striker
	module Command
		class Base < Striker::Settings
			
			attr_reader :args, :options

			def initialize(args, options, path)
				super(path)
				@args = args
				@options = options

				Striker.configure(Settings.new(path))
			end

		end
	end
end
