# frozen_string_literal: true
require 'openssl'
require 'base64'
require 'pry'
require 'faraday'

API_KEY = ENV['MYRACLOUD_API_KEY'].freeze
API_SECRET = ENV['MYRACLOUD_API_SECRET'].freeze
API_URL = 'https://api.myracloud.com'
$date = DateTime.now.to_s

def uri
  '/en/rapi/domains/1'
end

def signing_string
  [
    'd41d8cd98f00b204e9800998ecf8427e',
    'GET',
    uri,
    'application/json',
    $date
  ].join('#')
end

def signing_key
  intermediate = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), "MYRA#{API_SECRET}", $date)
  OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), intermediate, 'myra-api-request')
end

def signature
  Base64.strict_encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha512'), signing_key, signing_string))
end

conn = Faraday.new(url: API_URL)

response = conn.get(uri) do |req|
  req.headers['Authorization'] = "MYRA #{API_KEY}:#{signature}"
  req.headers['Content-Type'] = 'application/json'
  req.headers['Date'] = $date
end
