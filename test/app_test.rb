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
    2.times do |_| 
      timmy.add_contact('James', '0404040404', '23 King Street, Fitzroy, Victoria, 3065', 'crazy', 'lazy')
    end
    timmy.delete_contact(1)

    assert_equal(1, timmy.contacts.size)
    assert(timmy.contacts[2])
  end

  def test_display_contacts
    jimmy = Book.new('Jimmy')
    jimmy.add_contact('Tommy', '0404040404', '23 Lazy Cat St', 'lazy')
    test_arr = []
    jimmy.display_contacts.each do |entry|
      entry.each do |_, detail|
        test_arr << detail.to_s
      end
    end

    assert_equal(1, test_arr.size)
    assert_equal(4, test_arr.first.size)
  end
end
