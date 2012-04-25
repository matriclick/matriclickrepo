require(File.expand_path(File.join(File.dirname(__FILE__), 'table_builder', 'table_builder.rb')))
require(File.expand_path(File.join(File.dirname(__FILE__), 'table_builder', 'calendar_helper.rb')))

ActionView::Base.send :include, TableHelper
ActionView::Base.send :include, CalendarHelper