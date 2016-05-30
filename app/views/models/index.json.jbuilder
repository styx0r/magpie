json.array!(@models) do |model|
  json.extract! model, :id, :name, :path, :mainscript
  json.url model_url(model, format: :json)
end
