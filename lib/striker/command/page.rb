module Striker
	module Command
		class Page < Base

			def initialize(args, options, path)
				super(args, options, path)
			end

			def process
				if self.options[:new]
					page_name = self.options[:new].downcase
					title = self.options[:title]
					new_page page_name, title
					unless self.options[:no_media]
						new_media(page_name)
					end
				else
					raise ArgumentError, 'You need to provide a page name'
				end
			end

			private
			def new_page(page, title)
				begin
					File.open(File.join(Settings::PAGES_TEMPLATE, 'page.md'), 'r') do |file|

						front_matter = {
							'title' => title,
							'date' => Time.now.strftime("%Y-%m-%d"),
							'author' => get_author,
							'template' => 'page'
						}

						contents = Liquid::Template.parse(file.read).render front_matter 
						File.open(File.join(self.pages_dir, "#{page}.md"), "w") do |f|
							f.write contents
						end
					end
				rescue Exception => e
					p e.message
				end
			end


			def get_author
				Dir.chdir
				if File.exists? '.gitconfig'
					re = /name\s*=\s*(.*)/
					File.open('.gitconfig', 'r') do |file|
						match = file.read.match re
						if match
							match[1]
						else
							""
						end
					end
				else
					""
				end
			end

			def new_media(page)
				FileUtils.mkdir(File.join(self.media_dir, 'images', page)) unless self.options[:no_image]
				FileUtils.mkdir(File.join(self.media_dir, 'sounds', page)) unless self.options[:no_sound]
				FileUtils.mkdir(File.join(self.media_dir, 'videos', page)) unless self.options[:no_video]
			end

		end
	end
end
