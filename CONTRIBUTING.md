# Contributing to Authensure Ruby SDK

Thank you for your interest in contributing to the Authensure Ruby SDK!

## Getting Started

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/authensure-ruby.git
   cd authensure-ruby
   ```
3. Install dependencies:
   ```bash
   bundle install
   ```
4. Run tests:
   ```bash
   bundle exec rspec
   ```

## Development Workflow

1. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes following the code style guidelines

3. Write tests for your changes

4. Run the test suite:
   ```bash
   bundle exec rspec
   ```

5. Run the linter:
   ```bash
   bundle exec rubocop
   ```

6. Commit your changes:
   ```bash
   git commit -m "feat: Add your feature description"
   ```

7. Push and create a Pull Request

## Code Style

- Follow the Ruby Style Guide
- Use RuboCop for linting
- Write YARD documentation for public methods
- Use `frozen_string_literal: true` in all files

## Testing

- Write RSpec tests for all new functionality
- Use WebMock for HTTP stubbing
- Aim for high test coverage

## Commit Messages

Use conventional commits:
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation
- `test:` Tests
- `refactor:` Refactoring
- `chore:` Maintenance

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
