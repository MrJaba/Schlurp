require 'rubygems'
require 'faraday'
require 'JSON'
require 'ruby-debug'
require 'twitter-text'
require 'nokogiri'
require 'readability'
require 'yaml'
require 'webtagger'
require 'active_model'
require 'active_support'
require 'mongo_mapper'
require 'qu'
require 'qu-mongo'

MongoMapper.database = 'schlurp'

require_relative 'lib/user_timeline'
require_relative 'lib/link'
require_relative 'lib/tweeter'
require_relative 'lib/article'

# UserTimeline.new("mrjaba").run
