# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/app'

class AppTest < MiniTest::Test
  def test_create_contact_direct
    james = Contact.new('James', '0404040404', '23 King Street, Fitzroy, Victoria, 3065', ['lazy', 'crazy'])

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
    assert(x[0])
    assert_equal(1, x.size)
    assert_equal(2, x[0][:details][:category].size)
  end

  def test_delete_contact
    timmy = Book.new('Timmy')
    2.times do |_|
      timmy.add_contact('James', '0404040404', '23 King Street, Fitzroy, Victoria, 3065', 'crazy', 'lazy')
    end
    timmy.delete_contact(1)

    assert_equal(1, timmy.display_contacts.size)
    assert(timmy.display_contacts[0])
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

  def test_filter_contacts_name
    jimmy = Book.new('Jimmy')
    jimmy.add_contact('Tommy', '0404040404', '23 Lazy Cat St', 'lazy')
    jimmy.add_contact('Tommy', '0480808080', '1 Baker St', 'hungry', 'affectionate')
    jimmy.add_contact('Wimmy', '0404040401', '22 Lazy Cat St', 'sleepy')

    x = jimmy.filter_contacts('oMm')
    assert_instance_of(Array, x)
    assert_equal(2, x.size)
    assert_equal(0, x.first[:id])
    assert_raises(ArgumentError) do
      jimmy.filter_contacts
    end

    y = jimmy.filter_contacts('affec')
    assert_instance_of(Array, y)
    assert_equal(1, y.size)
    assert_equal(1, y.first[:id])
  end

  def test_valid_edit
    timmy = Book.new('Timmy')
    timmy.add_contact('James', '0404040404', '23 King Street, Fitzroy, Victoria, 3065', 'crazy', 'lazy')
    timmy.add_contact('Yimby', '0414048404', '10 Flippy Street, Northcote, Victoria, 3070')
    timmy.edit_contact(1, 'Yomby', '0414048405', '10 Flippy Street, Northcote, Victoria, 3070')

    assert_equal('Yomby', timmy.display_contacts[1][:details][:name])
    assert_equal('James', timmy.display_contacts[0][:details][:name])
    assert_equal('0414048405', timmy.display_contacts[1][:details][:phone_number])
    assert_equal('0404040404', timmy.display_contacts[0][:details][:phone_number])
    assert_nil(timmy.display_contacts[2])
  end

  def test_invalid_edit
    timmy = Book.new('Timmy')
    timmy.add_contact('James', '0404040404', '23 King Street, Fitzroy, Victoria, 3065', 'crazy', 'lazy')

    assert_raises(ArgumentError) do
      timmy.edit_contact('Jimmy', '0404040404', '23 King Street, Fitzroy, Victoria, 3065', 'crazy', 'lazy')
      timmy.edit_contact(2.0, 'Jimmy', '0404040404', '23 King Street, Fitzroy, Victoria, 3065', 'crazy', 'lazy')
      timmy.edit_contact(1, 'Jimmy', '0404040404', '23 King Street, Fitzroy, Victoria, 3065', 'crazy', 'lazy')
    end
  end
end
