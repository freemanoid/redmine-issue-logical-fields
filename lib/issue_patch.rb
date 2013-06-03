module IssuePatch
  module ClassMethods

  end

  module InstanceMethods
    def editable_custom_field_values_with_compare_type(user=nil)
      editable_custom_field_values_without_compare_type.reject { |v| v.custom_field.field_format == 'compare' }
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods

    receiver.class_eval do
      unloadable

      alias_method_chain :editable_custom_field_values, :compare_type
    end
  end
end
