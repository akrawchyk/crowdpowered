json.array!(@events) do |event|
  json.extract! event, :name, :deadline, :description, :website, :properties
  json.url event_url(event, format: :json)
end
