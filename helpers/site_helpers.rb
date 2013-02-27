module SiteHelpers

  def page_title
    title = "The86 Documentation"
    if data.page.title
      title << " | " + data.page.title
    end
    title
  end

  def page_description
    if data.page.description
      description = data.page.description
    else
      description = "The86 API Documentation"
    end
    description
  end

  # Usage
  # <%- each_example("Group") do |example| %>
  # ...
  # <% end %>
  def each_example(resource_name)
    dir = Pathname("examples") + resource_name
    Pathname.glob(dir + "*.yml").each do |path|
      data = YAML.load(path.read)
      example = ApiExample.new("podling.com", data)
      yield(example)
    end
  end

end
