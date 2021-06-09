def print_hello
  'hello'
end

class Book
  attr_reader :contacts

  def initialize(owner)
    @owner = owner
    @contacts = {}
    @contact_ids = []
  end

  def delete_contact(id)
    @contacts.delete(id)
  end

  def add_contact(name, phone_num, address, *category)
    @contacts[generate_contact_id] =  { details: Contact.new(name, phone_num, address, category).to_s }
  end

  def update_contact(field, value)

  end

  def display_contacts
    @contacts
  end

  def filter_contacts(name)
    @contacts.values
  end

  def generate_contact_id
    max = @contact_ids.max || 0 
    id = max + 1
    @contact_ids << id
    id
  end
end

class Contact
  attr_accessor :name, :phone_number, :address, :category

  def initialize(name, phone_num, address, *category)
    @contact = { name: name, phone_number: phone_num, address: address, category: category.flatten }
    @name = name
    @phone_number = phone_num
    @address = address
    @category = category.flatten
  end

  def to_s
    @contact
  end
end

x = Book.new('Andy')
x.add_contact('james', '040404', '1 Brown Rd', 'lazy', 'crazy')
x.add_contact('tommy', '1414141', '23 Lazy Cat St', 'lazy')
x.display_contacts