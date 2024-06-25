
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

      define_method method_name.to_sym do |data|
        message = CONFIG.dig("notifications", class_name_prefix, event)

        expressions = message.scan(/%{{{(.*?)}}}/).flatten

        expressions.each do |expression|
          message ["%{{{#{expression}}}}"] = evaluate(data, expression)
        end

        message
      end
    end
  end

  module InstanceMethods
    def evaluate(data, expression)
      exp_array = expression.split(".").map(&:to_sym)

      data.dig(*exp_array)
    end
  end

  def self.included(klass)
    klass.extend(ClassMethods)
    klass.include(InstanceMethods)
  end
end
