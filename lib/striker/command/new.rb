module Striker
	module Command
		class New

			# Generates new site and related directories
			def self.process(args, options)
				@site_name = args.join
				FileUtils.mkdir @site_name
				FileUtils.cp_r Dir.glob(File.expand_path('../../../new_site', __FILE__) + '/*'), File.join(Dir.pwd, @site_name)
				FileUtils.mkdir_p File.join(Settings::SOURCE_DIR, @site_name, "media")
				FileUtils.mkdir_p File.join(Settings::SOURCE_DIR, @site_name, "pages")
				FileUtils.mkdir_p File.join(Settings::SOURCE_DIR, @site_name, "media/images")
				FileUtils.mkdir_p File.join(Settings::SOURCE_DIR, @site_name, "media/videos")
				FileUtils.mkdir_p File.join(Settings::SOURCE_DIR, @site_name, "media/sounds")
				FileUtils.mkdir_p File.join(Settings::SOURCE_DIR, @site_name, "plugins")
				default_page
			end

			# TODO: Find an efficient way to handle this.
			def self.default_page
				Dir.chdir File.join(Settings::SOURCE_DIR, @site_name)
				File.open Settings::PAGES_TEMPLATE + '/page.md', 'r' do |file|

					front_matter = {
						'title' => 'Home Page',
						'date' => Time.now.strftime("%Y-%m-%d"),
						'author' => 'Your Name',
						'template' => 'page'
					}

					contents = Liquid::Template.parse(file.read).render front_matter 
					File.open(File.join("pages", "index.md"), "w") do |f|
						f.write contents
					end
				end
				FileUtils.mkdir_p(File.join(Settings::SOURCE_DIR, @site_name, "media/images", "index"))
			end

			private_class_method :default_page

		end
	end
end
