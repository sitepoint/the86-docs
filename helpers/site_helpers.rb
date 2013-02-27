module SiteHelpers

  def page_title
    title = "Podling Documentation"
    if data.page.title
      title << " | " + data.page.title
    end
    title
  end

  def page_description
    data.page.description || "Podling API Documentation"
  end

  def examples_for(resource_name)
    ApiExampleCollection.load "podling.com",
      Pathname("examples") + resource_name + "*.yml"
  end

end
