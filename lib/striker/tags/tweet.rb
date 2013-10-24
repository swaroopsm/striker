module Striker
	module Tags
		class Tweet < Liquid::Tag

			def initialize(tag, markup, tokens)
				super
				match = markup.match /\s?#\[([\w\-~$^*!?.:;+=\s]+)\]\s?@\[([\w\-~$^*!?.:;+=\s]+)\]/
				if match
					@hashtags = match[1].gsub(" ", ",")
					@mentions = match[2].gsub(" ", ",")
				end
			end

			def render(context)
				<<-TWEET
					<a href="https://twitter.com/share" class="twitter-share-button" data-via="smswaroop" data-hashtags="#{@hashtags}" data-related="#{@mentions}">Tweet</a>
					<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
				TWEET
			end

		end
	end
end

Liquid::Template.register_tag('tweet', Striker::Tags::Tweet)

