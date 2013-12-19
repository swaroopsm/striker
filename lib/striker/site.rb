module Striker
	class Site

		attr_reader :site_defaults

		def initialize(settings)
			@site_defaults = settings
		end

		def pages(ext=false)
			pages = []
			Dir.entries(@site_defaults.pages_dir).each do |page|
				unless page == '.' or page == '..'
					if ext
						pages << page 
					else
						pages << File.basename(page, File.extname(page))
					end
				end
			end
			pages
		end

		def logo
			logo = nil
			FileUtils.chdir File.join(@site_defaults.media_dir, "images")
			Dir.glob("*.{jpg,jpeg,bmp,gif,png,svg}").each do |i|
				if i.match(/^logo.(jpg|jpeg|bmp|gif|png|svg)/)
					logo = "logo." + $1
					break
				end
			end
			if logo
				FileUtils.cp(logo, File.join(@site_defaults.assets_dir, "images"))
				File.join @site_defaults.baseurl, @site_defaults.config['assets'], "images", logo
			else
				logo
			end
		end

		def sidebar
			sidebar_pages = []
			self.pages(true).each do |p|
				page = Page.new(p, { :site_defaults => @site_defaults })
				if page.meta['sidebar']
					sidebar_pages << { 'title' => page.title, 'url' => page.url, 'base_dir' => page.base_dir, 'position' => page.meta['sidebar']['position'] }
				end
			end
			sidebar_pages.sort_by{ |k,v| k['position'] }
		end

		# Returns all page links for the site
		def links
			links = {}
			self.pages(true).each do |p|
				page = Page.new(p, { :site_defaults => @site_defaults })
				links[page.base_dir] = page.url
			end
			links
		end

		def gallery
			Media::Image.gallerize(@site_defaults) if @site_defaults.config['gallerize'] 
			images = []
			Dir.chdir File.join(@site_defaults.assets_dir, "images")
			Dir.glob("gallery-*").sort.each_slice(2) do |g|
				images << { 'thumbnail' => self.urlize(g[1]), 'main' => self.urlize(g[0]) }
			end
			images
		end

		def urlize(image)
			File.join(@site_defaults.baseurl, @site_defaults.config['assets'], "images", image)
		end

		def meta
			data = {}
			data['config'] = self.site_defaults.config
			data['name'] = self.site_defaults.config['name']
			data['source'] = self.site_defaults.source
			data['config']['basepath'] = File.join "/", data['config']['basepath']
			data['assets'] = File.join "/", @site_defaults.baseurl, @site_defaults.config['assets']
			data['pages'] = self.pages(true) #Page.list_full
			data['tags'] = Tag.list_full(@site_defaults) if @site_defaults.config['tagged']
			data['archive'] = Archive.new(@site_defaults).list_full if @site_defaults.config['archive']
			data['logo'] = self.logo
			data['sidebar'] = self.sidebar
			data['links'] = self.links
			data['gallery'] = self.gallery
			data['_defaults'] = @site_defaults
			data
		end

	end
end
