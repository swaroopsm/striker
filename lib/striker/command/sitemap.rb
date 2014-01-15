module Striker
	module Command
		class Sitemap < Base

			SITEMAP_FILE = "sitemap.xml"
			ROBOTS_FILE = "robots.txt"

			def initialize(args, options, path)
				super(args, options, path)

				@site = Site.new
				@remote = @site.meta['server']['remote']
			end

			def process
				generate
			end

			def sitemap
				liquidize(sitemap_template)
			end

			def robots
				liquidize(robots_template)
			end

			private
			def generate
				generate_sitemap
				generate_robots
			end

			def generate_sitemap
				File.open(File.join(@site.settings.extras_dir, SITEMAP_FILE), "w") do |f|
					f.write(self.sitemap)
				end
			end

			def sitemap_data
				sitemap = []

				@site.meta['pages'].each do |page|
					temp_mod = File.mtime(File.join(@site.settings.templates_dir, page['template'] + ".html"))
					page_mod = File.mtime(File.join(@site.settings.pages_dir, page['filename']))

					loc = File.join("#{@remote['protocol']}://", "#{@remote['host']}#{page['url']}")
					lastmod = temp_mod > page_mod ? parse_date(temp_mod) : parse_date(page_mod)
					priority = page['homepage'] ? 1.0 : 0.9

					sitemap << { 'loc' => loc, 'lastmod' => lastmod, 'priority' => priority }
				end

				sitemap
			end


			def sitemap_template
				File.read(File.join(File.dirname(File.expand_path(__FILE__)), "templates/sitemap.xml"))
			end

			def robots_template
				File.read(File.join(File.dirname(File.expand_path(__FILE__)), "templates/robots.txt"))
			end
			
			def robots_data
				{ 
					'disallow' => File.join(@site.settings.baseurl, @site.settings.config['assets']),
					'sitemap' => File.join(@site.settings.baseurl, SITEMAP_FILE) 
				}
			end

			def parse_date(date)
				date.strftime("%Y-%m-%d")
			end

			def generate_robots
				File.open(File.join(@site.settings.extras_dir, ROBOTS_FILE), "w") do |f|
					f.write(self.robots)
				end
			end

			def liquidize(template)
				Liquid::Template.parse(template).render(
			  	'sitemap' => sitemap_data,
			  	'robots' => robots_data,
			  	'remote' => @remote
				)
			end

		end
	end
end
