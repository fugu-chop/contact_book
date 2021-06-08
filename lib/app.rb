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
    @contacts[generate_contact_id] =  { details: Contact.new(name, phone_num, address, category) }
  end

  def update_contact
  end

  def display_contacts
    for _, value in @contacts
      # I think I want to iterate through each pair, passing the key, value to the block
      yield(value[:details].to_s)
    end
  end

  def filter_contacts
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

# x = Book.new('Andy')
# x.add_contact('james', '040404', '040404', 'lazy', 'crazy')
# x.display_contacts do |item|
#   item.each do 
#   end
# end
