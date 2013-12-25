module Striker
	module Tags
		class Thumbnail < Liquid::Tag
			
			def initialize(tag, markup, tokens)
				super
				@markup = markup
				@tokens = tokens
				if m = markup.match(/(\d+)w\s(\d+)h\s?#?\[?([\w|\d|\-|\s]+)*\]?\s?\.?\[?([\w|\d|\-|\s]+)*\]?/)
					@width = m[1].to_i || ""
					@height = m[2].to_i || ""
					@id = m[3] || ""
					@class = m[4] || ""
				elsif m = markup.match(/(\d{1,3}\.{1}[\d]+)s{1}\s?#?\[?([\w|-|\s]+)*\]?\s?\.?\[?([\w|-|\s]+)*\]?/)
					@scale = m[1].to_f || ""
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
				settings = context.environments[0]['site']['settings']
				# image = Media::Image.new(nil, image_options = { :width => @width, :height => @height, :scale => @scale, :page => context['page'], :site_defaults => site_defaults })
				# image.thumbnailize
				# url = File.join(site_defaults.config['assets'], 'images', context['page']['thumbnail']['src'])
				Dir.chdir File.join(settings.media_dir, "images", context["page"]["base_dir"])
				Dir.glob("*{#{Media::Nimage::FORMATS.join(",")}}").each do |f|
					if f.match /^thumbnail/
						@filename = f
						break
					end
				end
				image = Media::Nimage.new(@filename)
				rename = context["page"]["base_dir"]
				@scale ? image.thumbnailize({ :factor => @scale, :rename => rename }) : image.thumbnailize({ :width => @width, :height => @height, :rename => rename })
				image.move({ :rename => context["page"]["base_dir"] })

				%Q{
					<img src="#{image.result['url']}" alt="#{context['page']['title']}"  id="#{@id}" class="#{@class}">
				}
			end

		end
	end
end

Liquid::Template.register_tag('thumbnail', Striker::Tags::Thumbnail)
