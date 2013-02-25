module UrlHelpers

  PAGES = %w{
    clients
    conversations
    groups
    posts
    users
  }

  FRONT_PAGE_SECTIONS = %w{
    authentication
    errors
    introduction
    message_formats
    representations
    versioning
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
