module Striker
	class Archive
		
		def self.list_full
			grouped_pages = []
			pages = []
			Dir.chdir(Settings::PAGES_DIR)
			Dir.glob("*[.md|markdown]").each do |page|
				grouped_pages << Page.new(page).page_data
			end
			if Settings::CONFIG['archive']['period'] == :year
				grouped_pages = grouped_pages.group_by{ |page| page['date'].strftime("%Y") }
			else
				grouped_pages = grouped_pages.group_by{ |page| [page['date'].strftime("%B"), page['date'].strftime("%Y")] }
			end
			grouped_pages.each do |p| 
				date = p[0].class == Array ? p[0].join(" ") : p[0]
				pages << { 'date' => date, 'pages' => p[1] }
			end
			pages
		end

	end
end
