require 'yaml'

module TimelineFu::Cache
  
  def cached_actor
    @_cached_actor ||= get_cached_object(:actor)
  end
  
  def cached_subject
    @_cached_subject ||= get_cached_object(:subject)
  end
  
  def cached_secondary_subject
    @_cached_secondary_subject ||=  get_cached_object(:secondary_subject)
  end
  
  def get_cached_object(obj)
    return YAML::load(self["#{obj}_data"])
  end
  
end