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

  def top_of_page_link
    '<a class="top-link" href="#container">Back to top</a>'
  end

  def nav_element(text, path)
    # Produces an element compatible with bootstrap's navbar, with
    # class="active" as appropriate.

    # current_resource.url is path relative to root e.g. 'users.html'
    # see http://middlemanapp.com/advanced/sitemap/
    li_class =
      (path == current_resource.url) ?
      'class="active"' : ""

    %{<li #{li_class}><a href="#{path}">#{text}</a>}
  end

end
