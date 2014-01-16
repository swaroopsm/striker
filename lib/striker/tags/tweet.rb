module Striker
	module Tags
		class Tweet < Liquid::Tag

			def initialize(tag, markup, tokens)
				super
				hashtags = markup.match /\s?#\[([\w\-~$^*!?.:;+=\s]+)\]/
				via = markup.match /\s?@\[([\w\-~$^*!?.:;+=\s]+)\]/
				@hashtags = hashtags[1].gsub(" ", ",") unless hashtags.nil?
				@via = via[1].gsub(" ", ",") unless via.nil?
			end

			def render(context)
				<<-TWEET
					<a href="https://twitter.com/share" class="twitter-share-button" data-via="#{@via}" data-hashtags="#{@hashtags}" data-related="#{@mentions}">Tweet</a>
					<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
				TWEET
			end

		end
	end
end

Liquid::Template.register_tag('tweet', Striker::Tags::Tweet)

