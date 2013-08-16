json.array!(@urls) do |url|
  json.extract! url, :original_url, :shortened_url, :status
  json.url url_url(url, format: :json)
end
