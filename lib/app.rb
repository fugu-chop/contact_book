# frozen_string_literal: true

def print_hello
  'hello'
end

class Book
  def initialize(owner)
    @owner = owner
    @contacts = {}
    @contact_ids = []
  end

  def delete_contact(id)
    @contacts.delete(id)
  end

  def add_contact(name, phone_num, address, *category)
    @contacts[generate_contact_id] = { details: Contact.new(name, phone_num, address, category).to_s }
  end

  def display_contacts
    @contacts
  end

  def filter_contacts(search_term)
    filtered_arr = display_contacts.map do |identifier, entry|
      { id: identifier, details: entry.select do |_key, details|
        details[:name].downcase.match(/#{search_term.downcase}/) ||
          details[:category].any? { |item| item.downcase.match(/#{search_term.downcase}/) }
      end[:details] }
    end

    filtered_arr.select { |entry| entry[:details] }
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

  def update_contact_name(value)
    self.name = value
  end
end
