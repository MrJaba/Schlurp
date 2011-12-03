class Link
  attr_reader :uri, :resolved, :content, :tags

  def initialize(uri)
    @uri = uri
  end

  def resolve
    response = Faraday.get uri
    @resolved = response.headers['location']
  end

  def fetch
   @content = Faraday.get(resolved).body
  end
  
  def article
    document = Nokogiri::HTML(content)
    article = Readability::Document.new(document, uri, nil).content
  end

  def tags
    tags = WebTagger.tag_with_alchemy( article_content, ENV['ALCHEMY_KEY'])
    tags += WebTagger.tag_with_tagthe( article_content ) 
  end

end
