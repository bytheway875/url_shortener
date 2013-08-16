json.array!(@urls) do |url|
  json.extract! url, :original_url, :shortened_extension, :status
  json.url url_url(url, format: :json)
end
