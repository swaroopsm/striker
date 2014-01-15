require 'fileutils'
require 'yaml'
require 'mime-types'
require 'redcarpet'
require 'liquid'
require 'date'

require_relative 'striker/version'
require_relative 'striker/settings'
require_relative 'striker/command/base'
require_relative 'striker/command/new'
require_relative 'striker/command/page'
require_relative 'striker/command/build'
require_relative 'striker/command/server'
require_relative 'striker/command/sync'
require_relative 'striker/command/sitemap'
require_relative 'striker/media/commons'
require_relative 'striker/site'
require_relative 'striker/media/base'
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
require_relative 'striker/tags/include_tag'
require_relative 'striker/blocks/section'
require_relative 'striker/blocks/highlight'

module Striker

	# Initial Setup
	def self.configure(settings)

		@@settings = settings

		plugins_dir = settings.plugins_dir

		# Require custom plugins
		if Dir.exists? plugins_dir
			Dir.chdir plugins_dir
			Dir.glob("*.rb").each do |plugin|
				require File.join plugins_dir, plugin
			end
		end

	end

	def self.settings
		@@settings
	end

end
