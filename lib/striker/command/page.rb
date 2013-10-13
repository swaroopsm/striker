module Striker
	module Command
		class Page

			def self.process(args, options)
				if options[:new] and args[0]
					new_page args[0].downcase
				else
					raise ArgumentError, 'You need to provide a page name'
				end
			end

			def self.new_page(page)
				begin
					FileUtils.cd Settings::PAGES_DIR
					# FileUtils.touch page+".md"
					File.open Settings::PAGES_TEMPLATE + '/page.md', 'r' do |file|

						front_matter = {
							'title' => page,
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

			private_class_method :get_author, :new_page

		end
	end
end
