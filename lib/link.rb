class Link
  attr_reader :uri, :resolved, :content, :tags, :article

  def self.perform(link)
    link = Link.new(link)
    link.run
  end

  def initialize(uri)
    @uri = uri
  end

  def run
    resolve_link
    fetch_content
    parse_article
    tag_article
  end

  def resolve_link
    response = Faraday.get uri
    @resolved = response.headers['location']
  end

  def fetch_content
   @content = Faraday.get(resolved).body
  end
  
  def parse_article
    document = Nokogiri::HTML(content)
    @article = Readability::Document.new(document, uri, nil).content
  end

  def tag_article
    tags = WebTagger.tag_with_alchemy( article_content, ENV['ALCHEMY_KEY'])
    tags += WebTagger.tag_with_tagthe( article_content ) 
  end

end
