# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV["API_ORIGIN"] || ""

    resource "*",
      headers: :any,
      expose: %w[access-token uid client],
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
