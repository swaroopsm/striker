require 'stringex_lite'
require 'safe_yaml'

SafeYAML::OPTIONS[:default_mode] = :safe

module Striker
	class Page


		attr_reader :meta, :content, :title, :name, :template, :base_dir, :permalink, :filename, :url

		def initialize(page)
			@filename = page
			@base_dir = File.basename page, File.extname(page)
			@page = File.join Settings::PAGES_DIR, page
			@meta = YAML.load_file(@page)
			@title = @meta['title']
			@content = extract_content.post_match
			@name = @meta['title'].to_url
			@meta['name'] = @base_dir
			@permalink = permalink_page
			@template = @meta['template']
			@url = page_url
		end
		
		def page_data
			data = self.meta
			data['url'] = self.url
			data['thumbnail'] = self.image.thumbnail
			data['name'] = self.name
			data['filename'] = self.filename
			data['base_dir'] = self.base_dir
			data['images'] = self.image.all

			data
		end

		def image
			Media::Image.new(self)
		end

		def self.list_full
			pages = []
			Dir.chdir(Settings::PAGES_DIR)
			Dir.glob("*[.md|markdown]").each do |page|
				pages << Page.new(page).page_data
			end
			pages
		end

		def sections
			process_sections
		end

		private
		def extract_content
			File.open(@page, 'r').read.match(/^(?<headers>---\s*\n.*?\n?)^(---\s*$\n?)/m)
		end

		def permalink_page
			unless Settings::CONFIG['homepage'] == @base_dir
				permalink_style = self.meta['permalink'] ? self.meta['permalink']['style'] : Settings::CONFIG['permalink']['style']
				pretty_url = self.meta['permalink'] ? self.meta['permalink']['pretty'] : Settings::CONFIG['permalink']['pretty']
				filename = permalink_style.split("/").map{ |p| process_permalink(p) }.join("/") unless permalink_style.is_a? Symbol
				if pretty_url
					FileUtils.mkdir_p(File.join(Settings::BASEPATH, filename))
					filename + "/index.html"
				else
					unpretty_filename = filename.split("/")[0...-1]
					FileUtils.mkdir_p(File.join(Settings::BASEPATH, unpretty_filename))
					filename + ".html"
				end
			else
				"index.html"
			end
		end

		def page_url
			if @permalink.match(/^index.html/)
				File.join "/", Settings::CONFIG['basepath']
			elsif @permalink.match(/^([\w\-\/]+)index.html$/)
				File.join("/", Settings::CONFIG['basepath'], $1)
			else
				File.join("/", Settings::CONFIG['basepath'], @permalink)
			end
		end

		def process_permalink(p)
			p.match(/^:([\w\-]+)/) ? self.meta[$1].to_s.to_url : p
		end

		def extract_sections
			sections = @content.scan /\{\% section(.*) \%\}/
			sections.size > 0 ? sections.flatten!.map!{ |s| s.strip } : []
		end

		def process_sections
			sections = []
			extract_sections.each do |section|
				match = @content.match /^\{\% section #{section} \%\}(.+)\{\% endsection #{section} \%\}$/m
				if match
					sections << { 'name' => section, 'content' => $1 }
				end
			end
			sections
		end

	end
end
