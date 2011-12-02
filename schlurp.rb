require 'rubygems'
require 'faraday'
require 'JSON'
require 'ruby-debug'
require 'twitter-text'
require 'nokogiri'
require 'readability'
require 'yaml'

connection = Faraday.new(:url => 'https://schlurp-api.apigee.com/v1/twitter/1/statuses/user_timeline.json?') do |builder|
  builder.use Faraday::Request::UrlEncoded  # convert request params as "www-form-urlencoded"
  builder.use Faraday::Response::Logger     # log the request to STDOUT
  builder.use Faraday::Adapter::NetHttp     # make http requests with Net::HTTP
end

response = connection.get do |request|
  request.params['smartkey']='29fb06fd-3935-4439-b896-e861156b4a87'
end

include Twitter::Extractor

timeline = JSON.parse(response.body) 
spoken_to = Hash.new{|name,frequency| name[frequency]= 0}
timeline.each{|tweet| extract_mentioned_screen_names(tweet['text']).each{|name| spoken_to[name] += 1 } }
timeline.each{|t| p t['text']}
links = timeline.collect{|tweet| extract_urls(tweet['text'])}.flatten
p spoken_to
p links

resolver = Faraday.new do |builder|
  builder.use Faraday::Adapter::NetHttp     # make http requests with Net::HTTP
end
  
resolved = links.collect do |link|
  response = resolver.get do |req|
    req.url link
  end
  response.headers['location']
end

resolved.each do |uri|
  response = resolver.get do |req|
    req.url uri
  end
  document = Nokogiri::HTML(response.body)
  p Readability::Document.new(document, uri, nil).content
end
