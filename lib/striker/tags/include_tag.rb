module Striker
	module Tags
		class IncludeTag < Liquid::Tag

			def initialize(tag, markup, tokens)
				super
				@file = markup.strip + ".html"
			end

			def render(context)
				Dir.chdir File.join( context.environments[0]['site']['source'], "includes" )
				template = File.read(@file)
				Liquid::Template.parse(template).render(
					'site' => context.environments[0]['site'],
					'page' => context.environments[0]['page'],
					'tagged' => context.environments[0]['tagged']
				)
			end

		end
	end
end

Liquid::Template.register_tag("include", Striker::Tags::IncludeTag)
