class UserTimeline
  include Twitter::Extractor

  attr_reader :user, :timeline

  def initialize(user)
    @user = user
  end
  
  def run
    @timeline = JSON.parse(fetch_timeline)
    people = parse_people
    links = parse_links
  end

private

  def fetch_timeline
    connection = Faraday.new(:url => 'https://schlurp-api.apigee.com/v1/twitter/1/statuses/user_timeline.json?') do |builder|
      builder.use Faraday::Request::UrlEncoded
    end

    connection.get do |request|
      request.params['smartkey'] ='29fb06fd-3935-4439-b896-e861156b4a87'
      request.params['screen_name'] = user
    end
  end

  def parse_people
    spoken_to = Hash.new{|name,frequency| name[frequency]= 0}
    timeline.each{|tweet| extract_mentioned_screen_names(tweet['text']).each{|name| spoken_to[name] += 1 } }
  end

  def parse_links
    timeline.collect{|tweet| extract_urls(tweet['text']).collect{|link| Link.new(link)}.flatten
  end


end