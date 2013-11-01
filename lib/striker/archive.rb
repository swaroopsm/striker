module Striker
	class Archive
		
		if File.exists? File.join(Settings::SOURCE_DIR, "config.yml")
			@@dir = Settings::CONFIG['archive']['style'] 
			@@period = Settings::CONFIG['archive']['period']
		end

		def self.process(site_meta)
			@@site_meta = site_meta
			FileUtils.mkdir_p(File.join(Settings::PUBLIC_DIR, @@dir))
			process_archive_dir
			process_files
		end

		def self.list_full
			grouped_pages = []
			pages = []
			Dir.chdir(Settings::PAGES_DIR)
			Dir.glob("*[.md|.markdown]").each do |page|
				grouped_pages << Page.new(page).page_data
			end
			if @@period == :year
				grouped_pages = grouped_pages.group_by{ |page| page['date'].strftime("%Y") }
			else
				grouped_pages = grouped_pages.group_by{ |page| [page['date'].strftime("%Y"), page['date'].strftime("%B")] }
			end
			grouped_pages.each do |p| 
				if p[0].class == Array
					date = Date.new(p[0][0].to_i, Date::MONTHNAMES.index(p[0][1]), 1)
					url = File.join(Settings::CONFIG['basename'], @@dir, date.year.to_s, date.month.to_s)
				else
					date = p[0]
					url = File.join(Settings::CONFIG['basename'], @@dir, date)
				end
				
				pages << { 'date' => date, 'pages' => p[1], 'url' => url }
			end
			pages
		end

		def self.process_archive_dir
			list_full.each do |archive|
				Dir.chdir(File.join(Settings::PUBLIC_DIR, @@dir))
				if archive['date'].class == Date
					FileUtils.mkdir_p(File.join(archive['date'].year.to_s, archive['date'].month.to_s))
				else
					FileUtils.mkdir_p(archive['date'].to_s)
				end
			end
		end

		def self.process_files
			@@site_meta['archive'].each do |archive|
				process_main_template(archive)
			end
		end

		def self.process_main_template(archive)
			Dir.chdir(Settings::TEMPLATES_DIR)
			template = File.read(File.join("archive", "index.html"))
			parsed_data = Liquid::Template.parse(template).render('site' => @@site_meta, 'archive' => archive)
			Dir.chdir(Settings::PUBLIC_DIR)
			File.open(File.join(Settings::PUBLIC_DIR, archive['url'], "index.html"), "w") do |file|
				file.write(parsed_data)
			end
		end

		private_class_method :process_archive_dir, :process_files, :process_main_template

	end
end
