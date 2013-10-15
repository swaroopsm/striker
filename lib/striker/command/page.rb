module Striker
	module Command
		class Page

			def self.process(args, options)
				if options[:new]
					page_name = options[:new].downcase
					title = options[:title]
					new_page page_name, title
					unless options[:no_media]
						new_media(options, page_name)
					end
				else
					raise ArgumentError, 'You need to provide a page name'
				end
			end

			def self.new_page(page, title)
				begin
					File.open Settings::PAGES_TEMPLATE + '/page.md', 'r' do |file|

						front_matter = {
							'title' => title,
							'date' => Time.now.strftime("%Y-%m-%d"),
							'author' => get_author,
							'template' => 'page'
						}

						contents = Liquid::Template.parse(file.read).render front_matter 
						File.open(File.join(Settings::PAGES_DIR, "#{page}.md"), "w") do |f|
							f.write contents
						end
					end
				rescue Exception => e
					p e.message
				end
			end


			def self.get_author
				Dir.chdir
				if File.exists? '.gitconfig'
					re = /name\s?=\s?(.*)/
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

			def self.new_media(options, page)
				FileUtils.mkdir(File.join(Settings::MEDIA_DIR, 'images', page)) unless options[:no_image]
				FileUtils.mkdir(File.join(Settings::MEDIA_DIR, 'sounds', page)) unless options[:no_sound]
				FileUtils.mkdir(File.join(Settings::MEDIA_DIR, 'videos', page)) unless options[:no_video]
			end

			private_class_method :get_author, :new_page, :new_media

		end
	end
end
