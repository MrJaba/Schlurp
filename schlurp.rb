require 'rubygems'
require 'faraday'
require 'JSON'
require 'ruby-debug'
require 'twitter-text'
require 'nokogiri'
require 'readability'
require 'yaml'
require 'webtagger'

include Twitter::Extractor

timeline = JSON.parse(response.body) 
p spoken_to
p links


  tags = WebTagger.tag_with_alchemy( article_content, ENV['ALCHEMY_KEY'])
  tags += WebTagger.tag_with_tagthe( article_content ) 
  p tags.uniq
end
