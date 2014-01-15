module Striker
	module Command
		class Sitemap < Base

			FILENAME = "sitemap.xml"

			def initialize(args, options, path)
				super(args, options, path)

				@site = Site.new
				@remote = @site.meta['server']['remote']
			end

			def generate
				generate_sitemap
			end

			def liquidize
				Liquid::Template.parse(sitemap_template).render(
			  	'sitemap' => sitemap_data
				)
			end

			private
			def generate_sitemap
				File.open(File.join(@site.settings.extras_dir, FILENAME), "w") do |f|
					f.write(self.liquidize)
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

			def parse_date(date)
				date.strftime("%Y-%m-%d")
			end

		end
	end
end
