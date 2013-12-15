module Striker
	class Site

		def self.pages(ext=false)
			pages = []
			Dir.entries(Settings::PAGES_DIR).each do |page|
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

		def self.sidebar
			sidebar_pages = []
			pages(true).each do |p|
				page = Page.new(p)
				if page.meta['sidebar']
					sidebar_pages << { 'title' => page.title, 'url' => page.url, 'base_dir' => page.base_dir, 'position' => page.meta['sidebar']['position'] }
				end
			end
			sidebar_pages.sort_by{ |k,v| k['position'] }
		end

		# Returns all page links for the site
		def self.links
			links = {}
			pages(true).each do |p|
				page = Page.new(p)
				links[page.base_dir] = page.url
			end
			links
		end

		def self.meta
			data = Settings::CONFIG
			data['basepath'] = File.join "/", data['basepath']
			data['pages'] = Page.list_full
			data['tags'] = Tag.list_full if Settings::CONFIG['tagged']
			data['archive'] = Archive.list_full if Settings::CONFIG['archive']
			data['logo'] = Striker::Media::Image.process_logo
			data['sidebar'] = sidebar
			data['links'] = links
			data
		end

	end
end
