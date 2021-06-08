def print_hello
  'hello'
end

CONTACT_IDS = []

class Book
  attr_reader :contacts

  def initialize(owner)
    @owner = owner
    @contacts = {}
  end

  def delete_contact(id)
  end

  def add_contact(name, phone_num, address, *category)
    @contacts[generate_contact_id] =  { details: Contact.new(name, phone_num, address) }
  end

  def update_contact
  end

  def display_contacts
  end

  def filter_contacts
  end

  def generate_contact_id
    max = CONTACT_IDS.max || 0 
    id = max + 1
    CONTACT_IDS << id
    id
  end
end

class Contact
  attr_reader :name, :phone_number, :address, :category

  def initialize(name, phone_num, address, *category)
    @contact = { name: name, phone_number: phone_num, address: address, category: category }
    @name = name
    @phone_number = phone_num
    @address = address
    @category = category
  end
end

# x = Book.new('Andy')
# x.add_contact('james', '040404', '040404', 'lazy', 'crazy')
