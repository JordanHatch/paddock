json.rel do
  json.prev prev_page_url(scope, params: { format: nil })
  json.next next_page_url(scope, params: { format: nil })
end

json.total scope.total_count
json.results_per_page scope.limit_value
json.current_page scope.current_page
json.total_pages scope.total_pages
