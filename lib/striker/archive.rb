module Striker
	class Archive < Site

		def initialize(settings)
			super(settings)
			@settings = self.site_defaults
			# @site_meta = self.meta
		
			if File.exists? File.join(@settings.source, "config.yml")
				if @settings.config['archive']
					@dir = @settings.config['archive'] 
					@full_path = File.join @settings.basepath, @dir
					@template_dir = File.join @settings.templates_dir, "archive"
				end
			end
		end

	 	def process
			FileUtils.mkdir_p(File.join(@settings.basepath, @dir))
			@site_meta = self.meta
			process_archive_dir
			process_files
		end

		def list_full
			grouped_pages = []
			pages = []
			Dir.chdir(@settings.pages_dir)
			Dir.glob("*[.md|.markdown]").each do |page|
				p = Page.new(page, { :site_defaults => @settings })
				# Ignore archive if set in page front matter
				grouped_pages << p.page_data unless p.meta['ignore_archive']
			end
			grouped_year_month_pages = grouped_pages.group_by{ |page| [ page['date'].strftime("%Y"), page['date'].strftime("%m") ] }
			@yearly_pages = grouped_pages.group_by{ |page| page['date'].strftime("%Y") }
			grouped_year_month_pages.each do |p| 
				if p[0].class == Array
					date = Date.new(p[0][0].to_i, p[0][1].to_i, 1)
					url = File.join(@dir, date.year.to_s, date.strftime("%m"))
				else
					date = p[0]
					url = File.join(@dir, date)
				end
				
				pages << { 'date' => date, 'pages' => p[1], 'url' => url }
			end
			pages
		end

		private
		def process_archive_dir
			self.list_full.each do |archive|
				Dir.chdir(File.join(@settings.basepath, @dir))
				if archive['date'].class == Date
					FileUtils.mkdir_p(File.join(archive['date'].year.to_s, archive['date'].strftime("%m")))
					# p File.join(archive['date'].year.to_s, archive['date'].strftime("%m").to_s)
				else
					FileUtils.mkdir_p(archive['date'].to_s)
				end
			end
		end

		def process_files

			# Process monthly archive
			self.list_full.each do |archive|
				process_main_template(archive)
			end

			# Process yearly archive
			Dir.chdir File.join(@settings.templates_dir, "archive")
			@yearly_pages.each do |page|

				template = File.read("yearly.html")
				months = page[1].group_by{ |pp| pp['date'].strftime("%m") }.keys.uniq
				parsed_data = Liquid::Template.parse(template).render('site' => @site_meta, 'pages' => page[1], 'year' => page[0], 'months' => months)

				File.open(File.join(@settings.basepath, @settings.config['archive'], page[0], "index.html"), "w") do |file|
					file.write(parsed_data)
				end
			end
		end

		def process_main_template(archive)
			Dir.chdir(@settings.templates_dir)

			template = File.read(File.join("archive", "monthly.html"))
			parsed_data = Liquid::Template.parse(template).render('site' => @site_meta, 'pages' => archive['pages'])
			Dir.chdir(@settings.basepath)
			File.open(File.join(@settings.basepath, archive['url'], "index.html"), "w") do |file|
				file.write(parsed_data)
			end
		end

		# private_class_method :process_archive_dir, :process_files, :process_main_template

	end
end
