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

  def endpoint(locals = {})
    defaults = {}
    all_locals = defaults.merge(locals)
    partial("endpoint", locals: all_locals)
  end

end
