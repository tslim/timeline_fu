require 'timeline_fu/fires'
require 'timeline_fu/job'
require 'timeline_fu/cache'

module TimelineFu
end

ActiveRecord::Base.send :include, TimelineFu::Fires
ActiveRecord::Base.send :include, TimelineFu::Cache
