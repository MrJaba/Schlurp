class Article
  include MongoMapper::Document
  key :uri, String
  key :content, String
  key :tags, Array
  key :link_count, Integer, :default => 1 
  timestamps!

  Article.ensure_index(:uri)
end
