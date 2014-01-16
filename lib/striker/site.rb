module Striker
	class Site

		include Media::Commons

		def settings
			Striker.settings
		end

		def page_files(ext=false)
			Dir.chdir(File.join(self.settings.pages_dir))
			pages = []
			Dir.glob("*").each do |page|
				if ext
					pages << page 
				else
					pages << File.basename(page, File.extname(page))
				end
			end
			pages
		end

		def pages
			pages = []
			self.page_files(true).each do |p|
				page = Page.new(p)
				pages << page.page_data
			end
			pages
		end

		def process_logo
			Dir.chdir(File.join(self.settings.media_dir, "images"))
			find("logo", Media::Image::FORMATS) do |f|
				image = Media::Image.new(f, { :sleep => true })
				image.move
			end
		end

		def logo
			Dir.chdir File.join(self.settings.assets_dir, "images")
			find("logo", Media::Image::FORMATS) do |f|
				logo = Media::Base.new(f)
				logo.referrer = "images"
				@logo = logo.result
			end
			@logo
		end

		def sidebar
			sidebar_pages = []
			self.page_files(true).each do |p|
				page = Page.new(p)
				if page.meta['sidebar']
					sidebar_pages << { 'title' => page.title, 'url' => page.url, 'base_dir' => page.base_dir, 'position' => page.meta['sidebar']['position'] }
				end
			end
			sidebar_pages.sort_by{ |k,v| k['position'] }
		end

		# Returns all page links for the site
		def links
			links = {}
			self.page_files(true).each do |p|
				page = Page.new(p)
				links[page.base_dir] = page.url
			end
			links
		end

		# Returns all images specific to a site
		def images
			images = {}
			Dir.chdir( File.join self.settings.public_dir, "assets/images" )
			Dir.glob("*{#{Media::Image::FORMATS.join(',')}}").each do |i|
				if i.match(/^site-1619-(.+)/)
					name = File.basename($1, File.extname($1))
					image = Media::Base.new(i)
					image.referrer = "images"
					images[name] = image.result
				end
			end

			images
		end

		def gallerize
			Dir.chdir File.join(self.settings.assets_dir, "images")
			FileUtils.mkdir_p("_gallery")
			images = Dir.glob(File.join(self.settings.gallery_dir, "*")).sort_by{ |g| File.mtime(g) }.reverse
			images.each do |g|
				image = Media::Image.new(g)
				image.gallerize
			end
		end

		def gallerized?
			self.gallery.size > 0
		end

		def gallery
			if self.settings.config['gallerize']
				images = []
				Dir.chdir File.join(self.settings.assets_dir, "images", "_gallery")
				Dir.glob("*").sort.each_slice(2) do |g|
					thumb = Media::Base.new(g[1])
					thumb.referrer = "images/_gallery"

					main = Media::Base.new(g[0])
					main.referrer = "images/_gallery"
					images << { 'thumbnail' => thumb.result, 'main' => main.result }
				end
				FileUtils.rm_rf(File.join("/", "tmp", "_gallery"))
				images
			end
		end

		def categories
			pages = []
			self.page_files(true).each do |p|
				page = Page.new(p)
				pages << page.page_data  if page.meta["category"]
			end
			if pages.size > 0
				pages.sort_by{ |p| [ p['date'], p['base_dir'] ] }.group_by{ |p| p['category'] }
			else
				pages
			end
		end

		def urlize(image)
			File.join(self.settings.baseurl, self.settings.config['assets'], "images", image)
		end

		def url
			if self.settings.server
				remote = self.settings.server['remote']
				@site_url = File.join("#{remote['protocol']}://", remote['host'])
			end

			@site_url
		end

		def meta
			data = {}
			data['config'] = self.settings.config
			data['server'] = self.settings.server
			data['name'] = self.settings.config['name']
			data['source'] = self.settings.source
			data['baseurl'] = File.join "/", data['config']['basepath']
			data['assets'] = File.join "/", self.settings.baseurl, self.settings.config['assets']
			data['pages'] = self.pages #Page.list_full
			data['tags'] = Tag.new.list_full if self.settings.config['tagged']
			data['archive'] = Archive.new.list_full if self.settings.config['archive']
			data['logo'] = self.logo
			data['sidebar'] = self.sidebar
			data['links'] = self.links
			data['gallery'] = self.gallery
			data['categories'] = self.categories
			data['settings'] = self.settings
			data['images'] = self.images
			data['url'] = self.url
			data
		end

	end
end
