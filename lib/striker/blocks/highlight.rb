module Striker
	module Blocks
		class Highlight < Liquid::Block

			def initialize(tag, markup, tokens)
				super
				@markup = markup
			end

			def render(context)
				<<-CODE
					<pre class='prettyprint lang-#{@markup}'>
						#{super}
					</pre>
				CODE
			end
		end
	end
end

Liquid::Template.register_tag("highlight", Striker::Blocks::Highlight)
