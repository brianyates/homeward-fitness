require 'carrierwave/orm/activerecord'

CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
    provider:              'AWS',
    aws_access_key_id:     ENV["S3_ACCESS_KEY"],
    aws_secret_access_key: ENV["S3_SECRET_KEY"],
    region:                'us-east-2',
    host:                  's3-us-east-2.amazonaws.com',
    endpoint:              'https://s3.us-east-2.amazonaws.com'
  }
  config.fog_directory  = 'homewardfitness'
  config.fog_public     = true
  config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" }
end