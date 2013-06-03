module ActsAsCustomizablePatch
  module ClassMethods

  end

  module InstanceMethods
    def custom_field_values_with_compare_type
      @custom_field_values ||= custom_field_values_without_compare_type.collect do |field|
        if field.custom_field.field_format == 'compare' && (operation = %w(< > <= >= ==).map(&:to_sym)[field.custom_field.operation_id])
          first_date = CustomField.find(field.custom_field.first_date_id).cast_value(custom_values.where(custom_field_id: field.custom_field.first_date_id).first.value)
          second_date = CustomField.find(field.custom_field.second_date_id).cast_value(custom_values.where(custom_field_id: field.custom_field.second_date_id).first.value)
          if first_date.send(operation, second_date)
            field.value = field.custom_field.true_message
          else
            field.value = field.custom_field.false_message
          end
        else
          field.value = ''
        end
        field
      end
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods

    receiver.class_eval do
      unloadable

      alias_method_chain :custom_field_values, :compare_type
    end
  end
end
