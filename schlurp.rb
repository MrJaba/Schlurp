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

MongoMapper.database = 'schlurp'

require_relative 'lib/user_timeline'
require_relative 'lib/link'
require_relative 'lib/tweeter'

UserTimeline.new("mrjaba").run
