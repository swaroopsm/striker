require 'stringex_lite'
require 'safe_yaml'

SafeYAML::OPTIONS[:default_mode] = :safe

module Striker
	class Page


		attr_reader :meta, :content, :title, :name, :template, :base_dir, :permalink

		def initialize(page)
			@base_dir = File.basename page, File.extname(page)
			@page = File.join Settings::PAGES_DIR, page
			@meta = YAML.load_file(@page)
			@title = @meta['title']
			@content = extract_content.post_match
			@name = @meta['title'].to_url
			@permalink = permalink_page
			@template = @meta['template']

			# @meta['images'] = self.image.all
			# @meta['thumbnail'] = self.image.thumbnail
			self.image.thumbnail
		end
		
		def page_data
			data = self.meta
			data['thumbnail'] = self.image.thumbnail
			data['name'] = self.name
			data['base_dir'] = self.base_dir
			data['images'] = self.image.all

			data
		end

		def image
			Media::Image.new(self)
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
					FileUtils.mkdir_p(File.join(Settings::PUBLIC_DIR, filename))
					filename + "/index.html"
				else
					filename + ".html"
				end
			else
				"index.html"
			end
		end

	end
end
