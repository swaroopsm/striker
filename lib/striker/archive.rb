module Striker
	class Archive
		
		def self.list_full
			grouped_pages = []
			pages = []
			Dir.chdir(Settings::PAGES_DIR)
			Dir.glob("*[.md|markdown]").each do |page|
				grouped_pages << Page.new(page).page_data
			end
			grouped_pages = grouped_pages.group_by{ |page| page['date'] }
			grouped_pages.each do |p|
				pages << { 'date' => p[0], 'pages' => p[1] }
			end
			pages
		end

	end
end
