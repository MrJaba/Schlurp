require 'qu'
require 'qu/tasks'
require './schlurp'

namespace :schlurp do
  task :fetch do
    Tweeter.all.sort_by {|t| t.frequency }.each do |tweeter|
      UserTimeline.new(tweeter.name).run
    end
  end
  task :fetch_initial do
    UserTimeline.new("mrjaba").run
  end
end
