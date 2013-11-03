module Striker
	module Tags
		class Thumbnail < Liquid::Tag
			
			def initialize(tag, markup, tokens)
				super
				@markup = markup
				@tokens = tokens
				if m = markup.match(/(\d+)w\s(\d+)h\s?#?\[?([\w|\d|\-|\s]+)*\]?\s?\.?\[?([\w|\d|\-|\s]+)*\]?/)
					@width = m[1] || ""
					@height = m[2] || ""
					@id = m[3] || ""
					@class = m[4] || ""
				elsif m = markup.match(/(\d{1,3}\.{1}[\d]+)s{1}\s?#?\[?([\w|-|\s]+)*\]?\s?\.?\[?([\w|-|\s]+)*\]?/)
					@scale = m[1] || ""
					@id = m[2] || ""
					@class = m[3] || ""
				else
					if m = markup.match(/#?\[?([\w|-|\s]+)*\]?\s?\.?\[?([\w|\s|-]+)*\]?/)
						@id = m[1] || ""
						@class = m[2] || ""
					end
				end
			end

			def render(context)
				image = Media::Image.new(nil, image_options = { :width => @width, :height => @height, :scale => @scale, :context => context['page'] })
				image.thumbnailize
				url = File.join(Settings::CONFIG['basepath'], Settings::CONFIG['assets'], 'images', context['page']['thumbnail']['src'])
				%Q{
					<img src="#{url}" alt="#{context['page']['title']}"  id="#{@id}" class="#{@class}">
				}
			end

		end
	end
end

Liquid::Template.register_tag('thumbnail', Striker::Tags::Thumbnail)
