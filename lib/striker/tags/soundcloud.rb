module Striker
	module Tags
		class SoundCloud < Liquid::Tag

			def initialize(tag, markup, tokens)
				super
				if m = markup.match(/^(\w+)\s?(\d+%?)w\s?(\d+%?)h/i)
					@sound_id = m[1]
					@width = m[2]
					@height = m[3]
				end
			end

			def render(context)
				if @sound_id
					<<-IFRAME
						<iframe width="#{@width}" height="#{@height}" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/#{@sound_id}"></iframe>
					IFRAME
				end
			end

		end
	end
end

Liquid::Template.register_tag('soundcloud', Striker::Tags::SoundCloud)
