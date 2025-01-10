Ckeditor.setup do |config|
  # ==> ORM configuration
  # Load and configure the ORM. Supports :active_record (default), :mongo_mapper and
  # :mongoid (bson_ext recommended) by default. Other ORMs may be
  # available as additional gems.
  require "ckeditor/orm/active_record"

  config.authorize_with :cancan

  config.cdn_url = "https://cdn.ckeditor.com/4.22.1/basic/ckeditor.js"
end
