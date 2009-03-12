class TimelineFuJob < Struct.new(:args)
  def perform
    args[:actor_data]             = args[:actor].to_yaml unless args[:actor].blank?
    args[:subject_data]           = args[:subject].to_yaml unless args[:subject].blank?
    args[:secondary_subject_data] = args[:secondary_subject].to_yaml unless args[:secondary_subject].blank?
    TimelineEvent.create!(args)
  end
end