# Sinatra Contact Book App
A repo to for contact book app using Sinatra.

### Basic Overview
This is a basic contacts management application written in Sinatra. 

Users are able to:
1. Log in/out
2. Add, update, delete contacts
3. Search for contacts
4. Filter for contact groups

### How to run
1. Clone the repo locally
2. Make sure you have the `bundle` gem installed.
2. Run `bundle install` in your CLI
3. Run `ruby routes.rb` in your CLI
4. Visit `http://localhost:4567` in your web browser
5. If you need to reset the app (i.e. delete all information), please delete the associated cookie through your browser.

Login credentials include:
```ruby
{
  # This is stored in a .env file
  admin: 'secret'
}
```
### Tests
Tests are found in the `test/` directory. There are two tests - one for the Sinatra routing (`routes_test.rb`), and one for the application logic itself (`app_test.rb`)
They can be executed through `bundle exec ruby *_test.rb`, where `*` is the appropriate filename.

### Design Choices

### Challenges
A few pointy bits that had me searching Stack Overflow and Google for:
- The `ENV` variable has to live in the root directory; this is what the `dotenv` gem expects when searching for it. This is necessary for the `Bcrypt` gem to access the `ENV` file.
- For some reason (I still can't figure out why), Rack still isn't able to access the `ENV` file - I have to manually set a session secret in order to run route related tests.
- HTML values truncate if there is a space (relevant when re-rendering a template with the old values); you have to wrap the entire value returned with quotes for it to fully show up.
