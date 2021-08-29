module IssuesHelper
  def azure_devops_link(identifier)
    base = ENV.fetch('AZURE_DEVOPS_BASE_URL') { '#' }
    "#{base}_workitems/edit/#{identifier}"
  end
end
