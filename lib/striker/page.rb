require 'stringex_lite'
require 'safe_yaml'

SafeYAML::OPTIONS[:default_mode] = :safe

module Striker
	class Page


		attr_reader :meta, :content, :title, :name, :template, :base_dir

		def initialize(page)
			@base_dir = File.basename page, File.extname(page)
			@page = File.join Settings::PAGES_DIR, page
			@meta = YAML.load_file(@page)
			@title = @meta['title']
			@content = extract_content.post_match
			@name = @meta['title'].to_url
			@template = @meta['template']

			@meta['images'] = self.image.all
			# @meta['thumbnail'] = self.image.thumbnail
			self.image.thumbnail
		end
		
		def image
			Media::Image.new(self)
		end

		private
		def extract_content
			File.open(@page, 'r').read.match(/^(?<headers>---\s*\n.*?\n?)^(---\s*$\n?)/m)
		end

	end
end
