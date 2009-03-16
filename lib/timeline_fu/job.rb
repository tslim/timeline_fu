class TimelineFuJob < Struct.new(:args)
  def perform
    TimelineEvent.create!(args)
  end
end