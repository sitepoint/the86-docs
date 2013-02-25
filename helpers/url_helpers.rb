module UrlHelpers

  PAGES = %w{
    users
    groups
    conversations
    posts
  }

  FRONT_PAGE_SECTIONS = %w{
    introduction
    versioning
    authentication
    message_formats
    errors
    representations
    webhooks
  }

  PAGES.each do |page|
    define_method "#{page}_path" do
      "/#{page}.html"
    end
  end

  FRONT_PAGE_SECTIONS.each do |section|
    define_method "#{section}_path" do
      "/##{section}"
    end
  end

end
