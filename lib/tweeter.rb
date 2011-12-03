class Tweeter
  include MongoMapper::Document
  key :name, String
  key :last_checked, DateTime
  key :frequency, Integer
  timestamps!

  Tweeter.ensure_index(:name)
end
