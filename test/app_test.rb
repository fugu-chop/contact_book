require 'minitest/autorun'
require_relative '../lib/app'

class AppTest < MiniTest::Test
  def test_create_contact_direct
    james = Contact.new('James', '0404040404', '23 King Street, Fitzroy, Victoria, 3065', 'lazy', 'crazy')

    assert_equal('James', james.name)
    assert_equal('0404040404', james.phone_number)
    assert_equal('23 King Street, Fitzroy, Victoria, 3065', james.address)
    assert_equal(2, james.category.size)
  end

  def test_create_incomplete_contact
    assert_raises(ArgumentError) do
      Contact.new('James', '0404040404')
    end
  end

  def test_create_blank_book
    trudy = Book.new('Trudy')

    assert_equal({}, trudy.contacts)
  end

  def test_create_book_no_name
    assert_raises(ArgumentError) do
      Book.new
    end
  end

  def test_create_contact_from_book
    andy = Book.new('Andy')
    andy.add_contact('James', '0404040404', '23 King Street, Fitzroy, Victoria, 3065', 'crazy', 'lazy')
    
    assert(andy.contacts[1])
    assert_equal(1, andy.contacts.size)
    assert_equal(2, andy.contacts[1][:details].category.size)
  end

  def test_delete_contact
    timmy = Book.new('Timmy')
    timmy.add_contact('James', '0404040404', '23 King Street, Fitzroy, Victoria, 3065', 'crazy', 'lazy')
    timmy.delete_contact(1)

    assert_equal({}, timmy.contacts)
  end
end
