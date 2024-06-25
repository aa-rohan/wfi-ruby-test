
require 'yaml'
require 'pry'

module Notifications
  CONFIG = YAML.load_file('notifications_config.yml')

  module ClassMethods
    def listens_to(event_name)

    end
  end

  module InstanceMethods

  end

  def self.included(klass)
    klass.extend(ClassMethods)
    klass.include(InstanceMethods)
  end
end
