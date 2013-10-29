module Striker
	class Archive
		
		def self.process
			FileUtils.mkdir_p(File.join(Settings::PUBLIC_DIR, Settings::CONFIG['archive']['style']))
			process_archive_dir
		end

		def self.list_full
			grouped_pages = []
			pages = []
			Dir.chdir(Settings::PAGES_DIR)
			Dir.glob("*[.md|.markdown]").each do |page|
				grouped_pages << Page.new(page).page_data
			end
			if Settings::CONFIG['archive']['period'] == :year
				grouped_pages = grouped_pages.group_by{ |page| page['date'].strftime("%Y") }
			else
				grouped_pages = grouped_pages.group_by{ |page| [page['date'].strftime("%Y"), page['date'].strftime("%B")] }
			end
			grouped_pages.each do |p| 
				date = p[0].class == Array ? Date.new(p[0][0].to_i, Date::MONTHNAMES.index(p[0][1]), 1): p[0]
				pages << { 'date' => date, 'pages' => p[1] }
			end
			pages
		end

		def self.process_archive_dir
			list_full.each do |archive|
				Dir.chdir(File.join(Settings::PUBLIC_DIR, Settings::CONFIG['archive']['style']))
				if archive['date'].class == Date
					FileUtils.mkdir_p(File.join(archive['date'].year.to_s, archive['date'].month.to_s))
				else
					FileUtils.mkdir_p(archive['date'].to_s)
				end
			end
		end

		private_class_method :process_archive_dir

	end
end
