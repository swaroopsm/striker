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

		def gallerize
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
			images = []
			Dir.chdir File.join(self.settings.assets_dir, "images")
			Dir.glob("gal-1619-*").sort.each_slice(2) do |g|
				thumb = Media::Base.new(g[1])
				thumb.referrer = "images"

				main = Media::Base.new(g[0])
				main.referrer = "images"
				images << { 'thumbnail' => thumb.result, 'main' => main.result }
			end
			images
		end

		def urlize(image)
			File.join(self.settings.baseurl, self.settings.config['assets'], "images", image)
		end

		def meta
			data = {}
			data['config'] = self.settings.config
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
			data['settings'] = self.settings
			data
		end

	end
end
