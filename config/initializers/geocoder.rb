Geocoder.configure(
  lookup: :google,
  timeout: 5,
  units: :mi,
  use_https: Rails.env.production?, 
  api_key: ENV['GOOGLE_MAPS_KEY']
)