
require 'yaml'
require 'pry'

module Notifications
  CONFIG = YAML.load_file('notifications_config.yml')

  module ClassMethods
    def listens_to(event_name)
      event = event_name.to_s
      class_name_prefix = name[0...name.index("Listener")].downcase

      define_method :"on_#{class_name_prefix}_#{event}" do |data|
        @data = data
        message = CONFIG.dig("notifications", class_name_prefix, event)

        format_message(message)
      end
    end
  end

  module InstanceMethods
    def format_message(message)
      expressions = message.scan(/%{{{(.*?)}}}/).flatten

      expressions.each do |expression|
        message ["%{{{#{expression}}}}"] = evaluate(expression)
      end

      message
    end

    def evaluate(expression)
      exp_array = expression.split(".").map(&:to_sym)

      @data.dig(*exp_array)
    end
  end

  def self.included(klass)
    klass.extend(ClassMethods)
    klass.include(InstanceMethods)
  end
end
