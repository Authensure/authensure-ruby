#!/usr/bin/env ruby
# frozen_string_literal: true

require "authensure"

api_key = ENV.fetch("AUTHENSURE_API_KEY", nil)
unless api_key
  puts "Error: AUTHENSURE_API_KEY environment variable not set"
  puts "Set it with: export AUTHENSURE_API_KEY='your_api_key_here'"
  exit 1
end

client = Authensure::Client.new(api_key: api_key)

puts "=== Authensure Ruby SDK Basic Usage ==="
puts

puts "Creating envelope..."
envelope = client.envelopes.create(
  name: "Contract Agreement",
  message: "Please review and sign this contract at your earliest convenience."
)
puts "Created envelope: #{envelope[:id]}"
puts "  Name: #{envelope[:name]}"
puts "  Status: #{envelope[:status]}"

puts
puts "Adding recipient..."
recipient = client.envelopes.add_recipient(
  envelope[:id],
  email: "signer@example.com",
  name: "John Doe",
  role: "signer"
)
puts "Added recipient: #{recipient[:id]}"
puts "  Email: #{recipient[:email]}"
puts "  Name: #{recipient[:name]}"

puts
puts "Fetching envelope details..."
envelope = client.envelopes.get(envelope[:id])
puts "Envelope has #{envelope[:recipients]&.length || 0} recipient(s)"

puts
puts "Listing all envelopes..."
envelopes = client.envelopes.list
puts "Found #{envelopes.length} envelope(s)"

puts
puts "Cleaning up..."
client.envelopes.delete(envelope[:id])
puts "Deleted test envelope"

puts
puts "=== Example Complete ==="
