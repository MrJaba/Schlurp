class Link
  attr_reader :uri, :resolved, :content, :tags, :article

  def self.perform(link)
    link = Link.new(link)
    link.run
  end

  def initialize(uri)
    @uri = normalise_uri(uri)
  end

  def run
    begin
      resolve_link
      update_article and return if article_fetched?
      fetch_content
      parse_article
      tag_article
      store_article
    rescue Exception => e
      puts "Failed: #{e.message}"
    end
  end

private
  
  def normalise_uri(uri)
    uri = uri.prepend("http://") if URI.parse(uri).scheme.nil?
    uri
  end

  def resolve_link
    response = Faraday.get uri
    @resolved = response.headers['location']
  end


  def update_article
    @article = Article.find_by_uri(resolved)
    @article.increment(link_count:1) if @article
  end

  def article_fetched?
    article.present? 
  end

  def fetch_content
    @content = Faraday.get(resolved).body
  end
  
  def parse_article
    document = Nokogiri::HTML(content)
    @article = Readability::Document.new(document, uri, nil).content
  end

  def tag_article
    tags = WebTagger.tag_with_alchemy( article, ENV['ALCHEMY_KEY'])
    tags += WebTagger.tag_with_tagthe( article ) 
  end

  def store_article
    Article.create({uri: resolved, content: article, tags: tags})
  end

end
