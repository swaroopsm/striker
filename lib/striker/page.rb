module Striker
	class Page
		
		attr_reader :meta, :content

		def initialize(page)
			page = Settings::PAGES_DIR + page
			@meta = YAML.load_file(page)
			extract_content = File.open(page, 'r').read.match(/^(?<headers>---\s*\n.*?\n?)^(---\s*$\n?)/m)
			@content = extract_content.post_match
		end

	end
end
