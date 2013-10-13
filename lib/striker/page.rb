module Striker
	class Page
		
		attr_reader :meta, :content, :title

		def initialize(page)
			page = Settings::PAGES_DIR + page
			@meta = YAML.load_file(page)
			@title = @meta['title']
			extract_content = File.open(page, 'r').read.match(/^(?<headers>---\s*\n.*?\n?)^(---\s*$\n?)/m)
			@content = extract_content.post_match
		end

	end
end
