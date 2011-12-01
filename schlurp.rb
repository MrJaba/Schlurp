require 'rubygems'
require 'faraday'
require 'JSON'
require 'ruby-debug'

connection = Faraday.new(:url => 'https://schlurp-api.apigee.com/v1/twitter/1/statuses/user_timeline.json?') do |builder|
  builder.use Faraday::Request::UrlEncoded  # convert request params as "www-form-urlencoded"
  builder.use Faraday::Response::Logger     # log the request to STDOUT
  builder.use Faraday::Adapter::NetHttp     # make http requests with Net::HTTP
end

response = connection.get do |request|
  request.params['smartkey']='29fb06fd-3935-4439-b896-e861156b4a87'
end

timeline = JSON.parse(response.body) 
spoken_to = Hash.new{|name,frequency| name[frequency]= 0}
timeline.each{|tweet| tweet['text'].scan(/@[a-z0-9_]+/i).each{|name| spoken_to[name] += 1 } }
p spoken_to
