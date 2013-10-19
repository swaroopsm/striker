module Striker
	module Tags
		class Vimeo < Liquid::Tag

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
						<iframe src="http://player.vimeo.com/video/#{@video_id}" width="#{@width}" height="#{@height}" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>
					IFRAME
				end
			end

		end
	end
end

Liquid::Template.register_tag('vimeo', Striker::Tags::Vimeo)
