require 'rubygems'
require 'faraday'

connection = Faraday.new(:url => 'https://schlurp-api.apigee.com/v1/twitter/1/statuses/user_timeline.json?') do |builder|
  builder.use Faraday::Request::UrlEncoded  # convert request params as "www-form-urlencoded"
  builder.use Faraday::Response::Logger     # log the request to STDOUT
  builder.use Faraday::Adapter::NetHttp     # make http requests with Net::HTTP
end

response = connection.get do |request|
  request.params['smartkey']='29fb06fd-3935-4439-b896-e861156b4a87'
end

p response
