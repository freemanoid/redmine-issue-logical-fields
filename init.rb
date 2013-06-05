require 'redmine'

Rails.configuration.to_prepare do
  require 'custom_field_patch'
  CustomField.send :include,                                  LogicalFields::CustomFieldPatch
  require 'queries_helper_patch'
  QueriesHelper.send :include,                                LogicalFields::QueriesHelperPatch
  require 'query_custom_field_column_patch'
  require_dependency 'query'
  QueryCustomFieldColumn.send :include,                       LogicalFields::QueryCustomFieldColumnPatch
  require 'acts_as_customizable_patch'
  require_dependency 'acts_as_customizable'
  Redmine::Acts::Customizable::InstanceMethods.send :include, LogicalFields::ActsAsCustomizablePatch
  require 'custom_field_format_patch'
  Redmine::CustomFieldFormat.send :include,                   LogicalFields::CustomFieldFormatPatch
  require File.join(File.dirname(__FILE__), 'lib', 'issue_patch')
  Issue.send :include,                                        LogicalFields::IssuePatch
end

Redmine::CustomFieldFormat.map do |fields|
  fields.register 'compare', only: %w(Issue)
end

class ViewsHooks < Redmine::Hook::ViewListener
  render_on :view_custom_fields_form_upper_box, :partial => "custom_fields/compare"
end

Redmine::Plugin.register :issue_logical_fields do
  name 'Issue Logical Fields plugin'
  author 'Alexandr Elhovenko'
  description 'Add logical issue custom fields '
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'alexandr.elhovenko@gmail.com'
end
