module CustomFieldFormatPatch
  module ClassMethods

  end

  module InstanceMethods
    def format_as_compare(value)
      value
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods

    receiver.class_eval do
      unloadable
    end
  end
end
