class UserTimeline
  include Twitter::Extractor

  attr_reader :user, :timeline

  def self.perform(screen_name)
    timeline = UserTimeline.new(screen_name)
    timeline.run
  end

  def initialize(screen_name)
    @user = screen_name
  end
  
  def run
    @timeline = JSON.parse(fetch_timeline)
    parse_mentions
    parse_links
  end

private

  def fetch_timeline
    connection = Faraday.new(:url => 'https://schlurp-api.apigee.com/v1/twitter/1/statuses/user_timeline.json?') do |builder|
      builder.use Faraday::Request::UrlEncoded
      builder.use Faraday::Adapter::NetHttp
    end

    response = connection.get do |request|
      request.params['smartkey'] ='29fb06fd-3935-4439-b896-e861156b4a87'
      request.params['screen_name'] = user
    end.body
  end

  def parse_mentions
    update_mention_frequencies(mention_frequencies)
  end

  def parse_links
    timeline_links.each do |link|
      Qu.enqueue Link, link
      puts "Pushed #{link}"
    end
  end

  def mention_frequencies
    spoken_to = Hash.new{|name,frequency| name[frequency]= 0}
    timeline.each do |tweet| 
      extract_mentioned_screen_names(tweet['text']).each do |name| 
        spoken_to[name] += 1
      end
    end
    spoken_to
  end
   
  def update_mention_frequencies(mentions)
    mentions.each do |person, count|
      tweeter = Tweeter.find_or_initialize_by_name(person)
      tweeter.frequency = (tweeter.frequency||0) + count
      tweeter.save
    end
  end

  def timeline_links
    timeline.collect{|tweet| extract_urls(tweet['text'])}.flatten
  end


end
