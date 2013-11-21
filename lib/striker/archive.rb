module Striker
	class Archive
		
		if File.exists? File.join(Settings::SOURCE_DIR, "config.yml")
			@@dir = Settings::CONFIG['archive'] 
			@@full_path = File.join Settings::BASEPATH, @@dir
			@@template_dir = File.join Settings::TEMPLATES_DIR, "archive"
		end

	 	def self.process(site_meta)
			@@site_meta = site_meta
			FileUtils.mkdir_p(File.join(Settings::BASEPATH, @@dir))
			process_archive_dir
			process_files
		end

		def self.list_full
			grouped_pages = []
			pages = []
			Dir.chdir(Settings::PAGES_DIR)
			Dir.glob("*[.md|.markdown]").each do |page|
				p = Page.new(page)
				# Ignore archive if set in page front matter
				grouped_pages << p.page_data unless p.meta['ignore_archive']
			end
			grouped_year_month_pages = grouped_pages.group_by{ |page| [ page['date'].strftime("%Y"), page['date'].strftime("%m") ] }
			@@yearly_pages = grouped_pages.group_by{ |page| page['date'].strftime("%Y") }
			grouped_year_month_pages.each do |p| 
				if p[0].class == Array
					date = Date.new(p[0][0].to_i, p[0][1].to_i, 1)
					url = File.join(@@dir, date.year.to_s, date.strftime("%m"))
				else
					date = p[0]
					url = File.join(@@dir, date)
				end
				
				pages << { 'date' => date, 'pages' => p[1], 'url' => url }
			end
			pages
		end

		def self.process_archive_dir
			list_full.each do |archive|
				Dir.chdir(File.join(Settings::BASEPATH, @@dir))
				if archive['date'].class == Date
					FileUtils.mkdir_p(File.join(archive['date'].year.to_s, archive['date'].strftime("%m").to_s))
				else
					FileUtils.mkdir_p(archive['date'].to_s)
				end
			end
		end

		def self.process_files

			# Process monthly archive
			@@site_meta['archive'].each do |archive|
				process_main_template(archive)
			end

			# Process yearly archive
			Dir.chdir @@template_dir
			@@yearly_pages.each do |page|

				template = File.read("yearly.html")
				months = page[1].group_by{ |pp| pp['date'].strftime("%m") }.keys.uniq
				parsed_data = Liquid::Template.parse(template).render('site' => @@site_meta, 'pages' => page[1], 'year' => page[0], 'months' => months)

				File.open(File.join(Settings::BASEPATH, page[0], "index.html"), "w") do |file|
					file.write(parsed_data)
				end
			end
		end

		def self.process_main_template(archive)
			Dir.chdir(Settings::TEMPLATES_DIR)

			template = File.read(File.join("archive", "monthly.html"))
			parsed_data = Liquid::Template.parse(template).render('site' => @@site_meta, 'pages' => archive['pages'])
			Dir.chdir(Settings::BASEPATH)
			File.open(File.join(Settings::BASEPATH, archive['url'], "index.html"), "w") do |file|
				file.write(parsed_data)
			end
		end

		private_class_method :process_archive_dir, :process_files, :process_main_template

	end
end
