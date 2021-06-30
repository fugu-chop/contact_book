# Sinatra Contact Book App
A repo to for contact book app using Sinatra.

### Basic Overview
This is a basic contacts management application written in Sinatra. 

Users are able to:
1. Log in/out
2. Add, update, delete contacts
3. Search for contacts
4. Filter for contact names and categories

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
Tests are found in the `test/` directory. There are two test files - one for the Sinatra routing (`routes_test.rb`), and one for the application logic itself (`app_test.rb`)
They can be executed through `bundle exec ruby *_test.rb`, where `*` is the appropriate filename.

### Design Choices
The application code is relatively simple. Storage of individual contact information (`Contact` objects) was done in a `Hash` object, with multiple contacts nested in another `Hash` (a `Book` object). This made it easy to fetch particular contacts by using an id as a key (which will probably be a lot easier when I start using databases for information storage instead of nested hashes), but posed some level of difficulty in respect of displaying the information in a fashion that oculd be interpreted by the `erb` templates - I had to use a method to fetch the contents of the hash, and then access objects that were nested a few layers deep by chaining multiple keys together, which made the code a little long and unwieldy. In respect of actually storing the `Book` object locally, this was done using the `session` hash that's available through Sinatra.

### Challenges
A few pointy bits that had me searching Stack Overflow and Google for:
- The `ENV` variable has to live in the root directory; this is what the `dotenv` gem expects when searching for it. This is necessary for the `Bcrypt` gem to access the `ENV` file.
- HTML values truncate if there is a space (relevant when re-rendering a template with the old values); you have to wrap the entire value returned with quotes for it to fully show up.
- Objects stored in the `params` are `String` objects - this caused a bit of headscratching when I couldn't access hash values, as the keys were `Integer` objects.
- `redirect` within Sinatra clears instance variables. This is annoying as it prevents you from persisting a value for the purpose of surfacing it in an html element on `redirect`. This was relevant when I tried to pass an invalid search term as a value to the `home.erb` template - it can't be done as far as I can see. I had to get around this by saving the search term to the `session` hash that's available irrespective of re-rendering a template or using `redirect`.
