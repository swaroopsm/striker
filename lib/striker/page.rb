require 'stringex_lite'
require 'safe_yaml'

SafeYAML::OPTIONS[:default_mode] = :safe

module Striker
	class Page


		attr_reader :meta, :content, :title, :name, :template

		def initialize(page)
			page = File.join Settings::PAGES_DIR, page
			@meta = YAML.load_file(page)
			@title = @meta['title']
			extract_content = File.open(page, 'r').read.match(/^(?<headers>---\s*\n.*?\n?)^(---\s*$\n?)/m)
			@content = extract_content.post_match
			@name = @meta['title'].to_url
			@template = @meta['template']
		end

	end
end
