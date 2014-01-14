require 'stringex_lite'
require 'safe_yaml'

SafeYAML::OPTIONS[:default_mode] = :safe

module Striker
	class Page < Site

		include Media::Commons

		attr_reader :meta, :content, :title, :name, :template, :base_dir, :permalink, :filename, :url, :images, :matter

		def initialize(page, options={})
			@filename = page
			@options = options
			@base_dir = File.basename page, File.extname(page)
			@page = File.join self.settings.pages_dir, page
			@meta = YAML.load_file(@page)
			@title = @meta['title']
			@matter = extract_content.post_match
			@name = @meta['title'].to_url
			@meta['name'] = @base_dir
			@permalink = permalink_page
			@template = Template.new(self, @options[:site_meta])
			@content = @template.liquidize
			@url = page_url
			move_media("images") if self.images.size < 1 and has_media?("images")
		end
		
		def page_data
			data = self.meta
			data['url'] = self.url
			data['thumbnail'] = self.thumbnail
			data['name'] = self.name
			data['filename'] = self.filename
			data['base_dir'] = self.base_dir
			data['images'] = self.images
			data['content'] = self.content
			data['tags'] = self.tags

			data
		end

		def images
			media_type("images")
		end

		def thumbnail
			Dir.chdir(File.join(self.settings.media_dir, "images", self.base_dir))
			Dir.glob("*").each do |i|
				image = Media::Image.new(i, { :sleep => true })
				if image.thumbnail?
					image.label = image.labelize({ :rename => self.base_dir })
					@thumb = image.result
				end
			end
			@thumb
		end

		def sections
			process_sections
		end

		def tags
			tags = []
			if self.meta['tagged']
				self.meta['tagged'].each do |tag|
					tags << { 'name' => tag, 'url' => File.join("/", self.settings.baseurl, self.settings.config['tagged']['permalink'], self.settings.config['tagged']['name'], tag.to_url) }
				end
			end
			tags
		end

		def process
			File.open(File.join(self.settings.basepath, "#{self.permalink}"), 'w') do |f|
				f.write @template.process		
			end
		end

		private
		def extract_content
			File.open(@page, 'r').read.match(/^(?<headers>---\s*\n.*?\n?)^(---\s*$\n?)/m)
		end

		def permalink_page
			unless self.settings.config['homepage'] == @base_dir
				permalink_style = self.meta['permalink'] ? self.meta['permalink']['style'] : self.settings.config['permalink']['style']
				pretty_url = self.meta['permalink'] ? self.meta['permalink']['pretty'] : self.settings.config['permalink']['pretty']
				filename = permalink_style.split("/").map{ |p| process_permalink(p) }.join("/") unless permalink_style.is_a? Symbol
				if pretty_url
					page = File.join(self.settings.basepath, filename, "index.html")
					FileUtils.mkdir_p(File.join(self.settings.basepath, filename)) unless permalinked?(page)
					filename + "/index.html"
				else
					unpretty_filename = filename.split("/")[0...-1]
					page = File.join(self.settings.basepath, filename + ".html")
					FileUtils.mkdir_p(File.join(self.settings.basepath, unpretty_filename)) unless permalinked?(page)
					filename + ".html"
				end
			else
				"index.html"
			end
		end

		def page_url
			if @permalink.match(/^index.html/)
				File.join "/", self.settings.config['basepath']
			elsif @permalink.match(/^([\w\-\/]+)index.html$/)
				File.join("/", self.settings.config['basepath'], $1)
			else
				File.join("/", self.settings.config['basepath'], @permalink)
			end
		end

		def process_permalink(p)
			p.match(/^:([\w\-]+)/) ? self.meta[$1].to_s.to_url : p
		end

		def permalinked?(page)
			File.exists? File.join(self.settings.public_dir, page)
		end


		def extract_sections
			sections = @matter.scan /\{\% section(.*) \%\}/
			sections.size > 0 ? sections.flatten!.map!{ |s| s.strip } : []
		end

		def process_sections
			sections = []
			extract_sections.each do |section|
				match = @matter.match /^\{\% section #{section} \%\}(.+)\{\% endsection #{section} \%\}$/m
				if match
					sections << { 'name' => section, 'content' => $1 }
				end
			end
			sections
		end

	end
end
