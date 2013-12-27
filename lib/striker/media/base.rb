module Striker
	module Media
		class Base < Site

			attr_reader :resource
			attr_writer :referrer

			def initialize(resource)
				@resource = resource
			end

			def referrer
				@referrer ? @referrer : self.class.name.downcase.split("::").last + "s"
			end

			def basename
				File.basename(@resource, File.extname(@resource))
			end

			def extname
				File.extname(@resource).downcase
			end

			def urlize
				File.join(
					self.settings.baseurl,
					self.settings.config['assets'],
					self.referrer,
					@resource
				)
			end

			def valid?
				self.class::FORMATS.include? self.extname
			end

			def labelize(options={})
				if(options[:prefix] and options[:postfix])
					label = options[:prefix] + " " + self.basename + " " + options[:postfix]
				elsif(options[:rename])
					label = options[:rename]
				elsif(options[:prefix])
					label = options[:prefix] + " " + self.basename
				elsif(options[:postfix])
					label = self.basename + " " +options[:postfix]
				else
					label = self.basename
				end

				label.to_url + self.extname
			end

			def content_type
				MIME::Types.type_for(self.extname)[0].content_type
			end

			def result
				{
					"url" => self.urlize,
					"src" => ( self.respond_to? :label ) ? self.label : self.labelize,
					"content_type" => self.content_type
				}
			end

		end
	end
end
