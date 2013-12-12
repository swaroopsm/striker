module Striker
	module Tags
		class IncludeTag < Liquid::Tag

			def initialize(tag, markup, tokens)
				super
				@file = markup.strip + ".html"
				@includes_dir = File.join Settings::SOURCE_DIR, "includes"
			end

			def render(context)
				Dir.chdir @includes_dir
				File.read(@file)
			end

		end
	end
end

Liquid::Template.register_tag("include", Striker::Tags::IncludeTag)
