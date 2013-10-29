module Striker
	class Archive
		
		def self.process
			FileUtils.mkdir_p(File.join(Settings::PUBLIC_DIR, Settings::CONFIG['archive']['style']))
			list_full
		end

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
				grouped_pages = grouped_pages.group_by{ |page| [page['date'].strftime("%Y"), page['date'].strftime("%B")] }
			end
			grouped_pages.each do |p| 
				process_archive_dir(p[0])
				date = p[0].class == Array ? p[0].join(" ") : p[0]
				pages << { 'date' => date, 'pages' => p[1] }
			end
			pages
		end

		def self.process_archive_dir(archive)
			Dir.chdir(File.join(Settings::PUBLIC_DIR, Settings::CONFIG['archive']['style']))
			month_number = Date::MONTHNAMES.index(archive[1]).to_s
			if archive.class == Array
				FileUtils.mkdir_p(File.join(archive[0], month_number))
			else
				FileUtils.mkdir_p(archive.to_s)
			end
		end

		private_class_method :process_archive_dir

	end
end
