require 'fileutils'
require 'yaml'
require 'mime-types'
require 'redcarpet'
require 'liquid'
require 'date'

require_relative 'striker/version'
require_relative 'striker/command/new'
require_relative 'striker/command/page'
require_relative 'striker/command/build'
require_relative 'striker/command/strike'
require_relative 'striker/settings'
require_relative 'striker/site'
require_relative 'striker/page'
require_relative 'striker/template'
require_relative 'striker/tag'
require_relative 'striker/archive'
require_relative 'striker/media/image'
require_relative 'striker/tags/thumbnail'
require_relative 'striker/tags/youtube'
require_relative 'striker/tags/vimeo'
require_relative 'striker/tags/soundcloud'
require_relative 'striker/tags/tweet'
require_relative 'striker/tags/gist'

# Require custom plugins
if Dir.exists? Striker::Settings::PLUGINS_DIR
	Dir.chdir Striker::Settings::PLUGINS_DIR
	Dir.glob("*.rb").each do |plugin|
		require File.join Striker::Settings::PLUGINS_DIR, plugin
	end
end

module Striker

end
