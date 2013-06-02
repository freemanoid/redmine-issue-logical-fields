module CustomFieldPatch
  module ClassMethods

  end

  module InstanceMethods
    def validate_custom_field_with_compare_type
      validate_custom_field_without_compare_type

      if field_format == 'compare'
        errors.add(:second_date_id, :must_be_different_from_first_date) if first_date_id == second_date_id
      end
    end

    def set_searchable_with_compare_type
      if field_format == 'compare'
        searchable = false
        multiple = false
      end
      set_searchable_without_compare_type
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods

    receiver.class_eval do
      unloadable

      alias_method_chain :validate_custom_field, :compare_type
      alias_method_chain :set_searchable, :compare_type

      validates_presence_of :first_date_id,  if: Proc.new { |obj| obj.field_format == 'compare' }
      validates_presence_of :second_date_id, if: Proc.new { |obj| obj.field_format == 'compare' }
      validates_presence_of :operation_id,   if: Proc.new { |obj| obj.field_format == 'compare' }
      validates_presence_of :true_message,   if: Proc.new { |obj| obj.field_format == 'compare' }
      validates_presence_of :false_message,  if: Proc.new { |obj| obj.field_format == 'compare' }
    end
  end
end
