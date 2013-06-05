module LogicalFields
  module QueryCustomFieldColumnPatch
    module ClassMethods

    end

    module InstanceMethods
      def value_with_compare_type(issue)
        if @cf.field_format == 'compare'
          operation = %w(< > <= >= ==).map(&:to_sym)[@cf.operation_id]
          return nil unless operation
          first_date = CustomField.find(@cf.first_date_id).cast_value(issue.custom_values.where(custom_field_id: @cf.first_date_id).first.value)
          second_date = CustomField.find(@cf.second_date_id).cast_value(issue.custom_values.where(custom_field_id: @cf.second_date_id).first.value)
          if first_date.send(operation, second_date)
            @cf.true_message
          else
            @cf.false_message
          end
        else
          value_without_compare_type(issue)
        end
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods

      receiver.class_eval do
        unloadable

        alias_method_chain :value, :compare_type
      end
    end
  end
end
