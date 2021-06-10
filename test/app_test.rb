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

    assert_equal({}, trudy.display_contacts)
  end

  def test_create_book_no_name
    assert_raises(ArgumentError) do
      Book.new
    end
  end

  def test_create_contact_from_book
    andy = Book.new('Andy')
    andy.add_contact('James', '0404040404', '23 King Street, Fitzroy, Victoria, 3065', 'crazy', 'lazy')
    
    x = andy.display_contacts
    assert(x[1])
    assert_equal(1, x.size)
    assert_equal(2, x[1][:details][:category].size)
  end

  def test_delete_contact
    timmy = Book.new('Timmy')
    2.times do |_| 
      timmy.add_contact('James', '0404040404', '23 King Street, Fitzroy, Victoria, 3065', 'crazy', 'lazy')
    end
    timmy.delete_contact(1)

    assert_equal(1, timmy.display_contacts.size)
    assert(timmy.display_contacts[2])
  end

  def test_display_contacts
    jimmy = Book.new('Jimmy')
    jimmy.add_contact('Tommy', '0404040404', '23 Lazy Cat St', 'lazy')
    jimmy.add_contact('Tommy', '0480808080', '1 Baker St', 'hungry', 'affectionate')
    jimmy.add_contact('Wimmy', '0404040401', '22 Lazy Cat St', 'sleepy')

    x = jimmy.display_contacts
    assert_instance_of(Hash, x)
    assert_equal(3, x.size)
    assert_equal('Tommy', x[1][:details][:name])
  end

  def test_filter_contacts
    jimmy = Book.new('Jimmy')
    jimmy.add_contact('Tommy', '0404040404', '23 Lazy Cat St', 'lazy')
    jimmy.add_contact('Tommy', '0480808080', '1 Baker St', 'hungry', 'affectionate')
    jimmy.add_contact('Wimmy', '0404040401', '22 Lazy Cat St', 'sleepy')

    x = jimmy.filter_contacts('Tommy')
    assert_instance_of(Array, x)
    assert_equal(2, x.size)
    assert_equal(1, x.first[:id])
    assert_raises(ArgumentError) do
      jimmy.filter_contacts
    end
  end
end
