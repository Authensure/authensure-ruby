# Authensure Ruby SDK

[![Gem Version](https://img.shields.io/gem/v/authensure.svg)](https://rubygems.org/gems/authensure)
[![Downloads](https://img.shields.io/gem/dt/authensure.svg)](https://rubygems.org/gems/authensure)
[![Ruby Version](https://img.shields.io/badge/ruby-%3E%3D%203.0-ruby.svg)](https://www.ruby-lang.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Official Ruby SDK for [Authensure](https://authensure.app) - the electronic signature and document authentication platform.

## Features

- **Full API Coverage** - Access all Authensure API endpoints
- **Ruby 3.0+** - Modern Ruby with full type annotations via YARD
- **Automatic Retries** - Built-in exponential backoff for transient errors
- **Rate Limit Handling** - Automatic rate limit detection and backoff
- **Webhook Verification** - Easy webhook signature verification
- **File Uploads** - Simplified document upload handling
- **Debug Mode** - Detailed logging for development

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'authensure'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install authensure
```

## Quick Start

```ruby
require 'authensure'

# Initialize with API key
client = Authensure::Client.new(api_key: 'your_api_key')

# Or use class methods
client = Authensure::Client.with_api_key('your_api_key')

# Create an envelope
envelope = client.envelopes.create(
  name: 'Contract Agreement',
  message: 'Please review and sign this document'
)

puts "Created envelope: #{envelope[:id]}"
```

## Configuration

### Global Configuration

```ruby
Authensure.configure do |config|
  config.api_key = 'your_api_key'
  config.base_url = 'https://api.authensure.app/api'  # Optional
  config.timeout = 30                                   # Optional
  config.retry_attempts = 3                             # Optional
  config.debug = false                                  # Optional
end

client = Authensure.client
```

### Per-Client Configuration

```ruby
client = Authensure::Client.new(
  api_key: 'your_api_key',
  base_url: 'https://api.authensure.app/api',
  timeout: 30,
  retry_attempts: 3,
  debug: true
)
```

### Using Access Token

```ruby
client = Authensure::Client.with_access_token('your_access_token')
```

## API Reference

### Envelopes

```ruby
# List envelopes
envelopes = client.envelopes.list(status: 'DRAFT')

# Get an envelope
envelope = client.envelopes.get('envelope_id')

# Create an envelope
envelope = client.envelopes.create(name: 'My Contract', message: 'Please sign')

# Add a recipient
recipient = client.envelopes.add_recipient(
  'envelope_id',
  email: 'signer@example.com',
  name: 'John Doe',
  role: 'signer'
)

# Send for signing
envelope = client.envelopes.send_envelope('envelope_id')

# Void an envelope
envelope = client.envelopes.void('envelope_id', reason: 'Contract cancelled')
```

### Documents

```ruby
# Upload a document
document = client.documents.upload(
  envelope_id: 'envelope_id',
  file: File.read('contract.pdf'),
  filename: 'contract.pdf'
)

# Get signed document URL
result = client.documents.get_signed_url('document_id')
puts result[:url]

# Download a document
content = client.documents.download('document_id')
```

### Templates

```ruby
# List templates
templates = client.templates.list

# Create from template
envelope = client.templates.use(
  'template_id',
  name: 'New Contract',
  recipients: [
    { roleId: 'role_1', email: 'signer@example.com', name: 'John Doe' }
  ]
)
```

### Contacts

```ruby
# List contacts
contacts = client.contacts.list(search: 'acme', limit: 20)

# Create a contact
contact = client.contacts.create(
  email: 'contact@example.com',
  name: 'Jane Smith',
  company: 'Acme Inc'
)
```

### Webhooks

```ruby
# Create a webhook
webhook = client.webhooks.create(
  url: 'https://your-app.com/webhooks/authensure',
  events: ['envelope.signed', 'envelope.completed']
)

# Verify webhook signature
is_valid = Authensure::Resources::Webhooks.verify_signature(
  payload,
  signature,
  'your_webhook_secret'
)

# Construct verified event
event = Authensure::Resources::Webhooks.construct_event(
  payload,
  signature,
  'your_webhook_secret'
)
puts "Event type: #{event[:event]}"
```

## Error Handling

```ruby
begin
  envelope = client.envelopes.get('invalid_id')
rescue Authensure::NotFoundError
  puts 'Envelope not found'
rescue Authensure::AuthenticationError
  puts 'Invalid API key'
rescue Authensure::RateLimitError => e
  puts "Rate limited, retry after: #{e.retry_after} seconds"
rescue Authensure::ValidationError => e
  puts "Validation errors: #{e.validation_errors}"
rescue Authensure::Error => e
  puts "API error: #{e.message} (code: #{e.code})"
end
```

## Rails Integration

Add to your `config/initializers/authensure.rb`:

```ruby
Authensure.configure do |config|
  config.api_key = Rails.application.credentials.authensure_api_key
  config.debug = Rails.env.development?
end
```

Use in your controllers:

```ruby
class EnvelopesController < ApplicationController
  def create
    envelope = authensure_client.envelopes.create(
      name: params[:name],
      message: params[:message]
    )
    render json: envelope
  end

  private

  def authensure_client
    @authensure_client ||= Authensure.client
  end
end
```

## Development

After checking out the repo:

```bash
bundle install
```

Run the tests:

```bash
bundle exec rspec
```

Run the linter:

```bash
bundle exec rubocop
```

## Resources

- [Documentation](https://authensure.app/docs/sdk/ruby)
- [API Reference](https://authensure.app/dashboard/developers)
- [GitHub Repository](https://github.com/Authensure/authensure-ruby)
- [RubyGems](https://rubygems.org/gems/authensure)
- [Report Issues](https://github.com/Authensure/authensure-ruby/issues)

## License

This gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
