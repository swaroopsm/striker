module Striker
	module Tags
		class Gist < Liquid::Tag

			def initialize(tag, markup, tokens)
				super
				@username = markup.split(" ")[0]
				@file = markup.split(" ")[1].strip + ".js"
			end

			def render(context)
				<<-GIST
					<script src="https://gist.github.com/#{@username}/#{@file}"></script>
				GIST
			end

		end
	end
end

Liquid::Template.register_tag('gist', Striker::Tags::Gist)

