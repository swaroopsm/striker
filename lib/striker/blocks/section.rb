module Striker
	module Blocks
		class Section < Liquid::Block

			def initialize(tag, markup, tokens)
				super
			end

			def render(context)

			end

		end
	end
end

Liquid::Template.register_tag("section", Striker::Blocks::Section)
