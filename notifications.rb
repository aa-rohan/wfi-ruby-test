
require 'yaml'
require 'pry'

module Notifications
  CONFIG = YAML.load_file('notifications_config.yml')

  module ClassMethods
    def listens_to(event_name)
      index = name.index("Listener")
      class_name_prefix = name.slice(0...index).downcase
      event = event_name.to_s

      method_name = "on_#{class_name_prefix}_#{event}"
    end
  end

  module InstanceMethods

  end

  def self.included(klass)
    klass.extend(ClassMethods)
    klass.include(InstanceMethods)
  end
end
