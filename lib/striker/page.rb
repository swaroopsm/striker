require 'stringex_lite'
require 'safe_yaml'

SafeYAML::OPTIONS[:default_mode] = :safe

module Striker
	class Page


		attr_reader :meta, :content, :title, :name, :template, :base_dir, :permalink, :filename

		def initialize(page)
			@filename = page
			@base_dir = File.basename page, File.extname(page)
			@page = File.join Settings::PAGES_DIR, page
			@meta = YAML.load_file(@page)
			@title = @meta['title']
			@content = extract_content.post_match
			@name = @meta['title'].to_url
			@permalink = permalink_page
			@template = @meta['template']
		end
		
		def page_data
			data = self.meta
			data['url'] = page_url
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

		private
		def extract_content
			File.open(@page, 'r').read.match(/^(?<headers>---\s*\n.*?\n?)^(---\s*$\n?)/m)
		end

		def permalink_page
			unless Settings::CONFIG['homepage'] == @base_dir
				filename = case Settings::CONFIG['permalink']['style']
										when :name
											@base_dir
										when :title
											@name
										else
											@name
										end
				if Settings::CONFIG['permalink']['pretty']
					FileUtils.mkdir_p(File.join(Settings::BASEPATH, filename)) 
					filename + "/index.html"
				else
					filename + ".html"
				end
			else
				"index.html"
			end
		end

		def page_url
			if @permalink.match(/^index.html/)
				File.join Settings::CONFIG['basepath']
			elsif @permalink.match(/^([\w-]+)\/(index.html)/)
				File.join(Settings::CONFIG['basepath'], $1)
			else
				File.join(Settings::CONFIG['basepath'], @permalink)
			end
		end

	end
end
