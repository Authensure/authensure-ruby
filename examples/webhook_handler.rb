#!/usr/bin/env ruby
# frozen_string_literal: true

require "authensure"
require "sinatra"
require "json"

WEBHOOK_SECRET = ENV.fetch("AUTHENSURE_WEBHOOK_SECRET", "")

post "/webhooks/authensure" do
  payload = request.body.read
  signature = request.env["HTTP_X_AUTHENSURE_SIGNATURE"] || ""

  begin
    event = Authensure::Resources::Webhooks.construct_event(payload, signature, WEBHOOK_SECRET)
  rescue Authensure::Error => e
    puts "Webhook signature verification failed: #{e.message}"
    halt 401, { error: "Invalid signature" }.to_json
  end

  puts "=" * 50
  puts "Received webhook event: #{event[:event]}"
  puts "Timestamp: #{event[:timestamp]}"
  puts "=" * 50

  case event[:event]
  when "envelope.created"
    puts "Envelope created: #{event[:data]["envelopeId"]}"
  when "envelope.sent"
    puts "Envelope sent: #{event[:data]["envelopeId"]}"
  when "envelope.viewed"
    puts "Envelope viewed by: #{event[:data]["recipientEmail"]}"
  when "envelope.signed"
    puts "Envelope signed by: #{event[:data]["recipientName"]}"
  when "envelope.completed"
    puts "Envelope completed: #{event[:data]["envelopeId"]}"
  when "envelope.declined"
    puts "Envelope declined by: #{event[:data]["recipientEmail"]}"
    puts "Reason: #{event[:data]["declineReason"]}"
  when "envelope.voided"
    puts "Envelope voided: #{event[:data]["envelopeId"]}"
  else
    puts "Unhandled event type: #{event[:event]}"
    puts "Data: #{JSON.pretty_generate(event[:data])}"
  end

  { received: true }.to_json
end

get "/health" do
  { status: "healthy" }.to_json
end

if __FILE__ == $PROGRAM_NAME
  puts "Starting Authensure webhook server..."
  puts "Listening on: http://localhost:4567/webhooks/authensure"
  puts "Health check: http://localhost:4567/health"
  puts
  puts "Warning: AUTHENSURE_WEBHOOK_SECRET not set" if WEBHOOK_SECRET.empty?
end
