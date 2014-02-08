module Striker
	module Command
		class New < Base

			def initialize(args, options, path)
				super(args, options, path)
			end

			# Generates new site and related directories
			def process
				begin
					@site_name = self.args.join
					FileUtils.mkdir @site_name
					FileUtils.cp_r Dir.glob(File.expand_path('../../../new_site', __FILE__) + '/*'), File.join(self.source, @site_name)
					FileUtils.mkdir_p File.join(self.source, @site_name, "media")
					FileUtils.mkdir_p File.join(self.source, @site_name, "pages")
					FileUtils.mkdir_p File.join(self.source, @site_name, "media/images")
					FileUtils.mkdir_p File.join(self.source, @site_name, "media/videos")
					FileUtils.mkdir_p File.join(self.source, @site_name, "media/sounds")
					FileUtils.mkdir_p File.join(self.source, @site_name, "includes")
					FileUtils.mkdir_p File.join(self.source, @site_name, "plugins")
					FileUtils.mkdir_p File.join(self.source, @site_name, "extras")
					default_page

					p "#{@site_name} created."
				rescue Exception => e
					p e
				end
			end

			private

			# TODO: Find an efficient way to handle this.
			def default_page
				Dir.chdir File.join(self.source, @site_name)
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
				FileUtils.mkdir_p(File.join(self.source, @site_name, "media/images", "index"))
			end

		end
	end
end
