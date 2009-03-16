module TimelineFu
  module Fires
    def self.included(klass)
      klass.send(:extend, ClassMethods)
    end

    module ClassMethods
      def fires(event_type, opts)
        raise ArgumentError, "Argument :on is mandatory" unless opts.has_key?(:on)
        opts[:subject] = :self unless opts.has_key?(:subject)

        method_name = :"fire_#{event_type}_after_#{opts[:on]}"
        define_method(method_name) do
          create_options = [:actor, :subject, :secondary_subject].inject({}) do |memo, sym|
            case opts[sym]
            when :self
              memo[sym] = self
            else
              memo[sym] = send(opts[sym]) if opts[sym]
            end
            memo
          end
          create_options[:event_type] = event_type.to_s
          
          # Cache actor/subjects
          create_options[:actor_data]             = create_options[:actor].to_yaml unless create_options[:actor].blank?
          create_options[:subject_data]           = create_options[:subject].to_yaml unless create_options[:subject].blank?
          create_options[:secondary_subject_data] = create_options[:secondary_subject].to_yaml unless create_options[:secondary_subject].blank?

          # Load timeline_fu.yml if found
          settings = { "use_delayed_job" => "true" }
          config_path = File.join(Rails.root, "config", "timeline_fu.yml")
          settings = YAML::load(File.open(config_path))[Rails.env] if File.exists?(config_path)
                              
          if settings["use_delayed_job"]
            Delayed::Job.enqueue TimelineFuJob.new(create_options)
          else
            TimelineEvent.create!(create_options)
          end
        end

        send(:"after_#{opts[:on]}", method_name, :if => opts[:if])
      end
    end
  end
end
