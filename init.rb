require 'redmine'

Redmine::CustomFieldFormat.map do |fields|
  fields.register 'compare', only: %w(Issue)
end

class ViewsHooks < Redmine::Hook::ViewListener
  render_on :view_custom_fields_form_upper_box, :partial => "custom_fields/compare"
end

Rails.configuration.to_prepare do
  require 'custom_field_patch'
  CustomField.send :include, CustomFieldPatch
  require 'queries_helper_patch'
  QueriesHelper.send :include, QueriesHelperPatch
  require 'query_custom_field_column_patch'
  require_dependency 'query'
  QueryCustomFieldColumn.send :include, QueryCustomFieldColumnPatch
end

Redmine::Plugin.register :issue_logical_fields do
  name 'Issue Logical Fields plugin'
  author 'Alexandr Elhovenko'
  description 'Add logical issue custom fields '
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'alexandr.elhovenko@gmail.com'
end
