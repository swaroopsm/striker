module Striker
	module Tags
		class Youtube < Liquid::Tag

			def initialize(tag, markup, tokens)
				super
				if m = markup.match(/^(\w+)\s?(\d+%?)w\s?(\d+%?)h/i)
					@video_id = m[1]
					@width = m[2]
					@height = m[3]
				end
			end

			def render(context)
				if @video_id
					<<-IFRAME
						<iframe width="#{@width}" height="#{@height}" src="http://www.youtube.com/embed/#{@video_id}"></iframe>
					IFRAME
				end
			end

		end
	end
end

Liquid::Template.register_tag('youtube', Striker::Tags::Youtube)
