def seed_test_data
  commodities = ["milk", "chocolate", "orange", "apple", "soap", "bread", "butter"]
  products = []
  commodities.size.times do |i|
    products << {id: i, name: commodities[i], price: rand(10), quantity: rand(1..10)}
  end
  products
end

def add basket, warehouse, prod

  if index_in_warehause = warehouse.index { |product| product[:name] == prod && product[:quantity] > 0 } # check if product exist and is available
    warehouse[index_in_warehause][:quantity] -= 1 if warehouse[index_in_warehause][:quantity] > 0 # # at least one is already in a basket
    if index_in_basket = basket.index { |product| product[:name] == prod }
      basket[index_in_basket][:quantity] += 1 # increment count of a given product
    else # there is no such product in a basket yet
      to_buy = warehouse[index_in_warehause].clone
      to_buy[:quantity] = 1
      basket << to_buy # add brand new product to the basket
    end
  end
  [basket, warehouse] # since there is no passing by reference in ruby i return vals to overwrite not up to date ones
end

def remove basket, warehouse, prod
  if index_in_basket = basket.index { |product| product[:name] == prod } # check if requested product is in a basket
    basket[index_in_basket][:quantity] == 1 ? basket.delete_at(index_in_basket) : basket[index_in_basket][:quantity] -= 1 #one single product-delete hash, if more decrement count
    index_in_warehause = warehouse.index { |product| product[:name] == prod } # find "place" for the product in a magazine
    warehouse[index_in_warehause][:quantity] += 1 # put it back
  end
  [basket, warehouse]
end

def price_brutto basket
  price_netto(basket) * 1.23
end

def price_netto basket
  basket.inject(0) { |sum, n| sum + n[:price] * n[:quantity] }
end

def resit basket
  puts '**************'
  puts "**BIEDRONKA**"
  puts '**************'
  basket.each do |product|
    puts "#{product[:name]} -- #{product[:quantity]} szt. -- #{ product[:quantity]}  * #{ product[:price]} zł"
  end
  puts '**************'
  puts "Total brutto: #{price_brutto basket} zł"
  puts "Total netto: #{price_netto basket} zł"
  puts "===================\n\n"
  puts "Thank you for shopping, see you soon!"
end

# Testing..

warehouse = seed_test_data
# puts "warehose before buying:\n" + warehouse.inspect
basket = []
# puts "Basket: \n" + basket.inspect
100.times do
  basket, warehouse = add basket, warehouse, "apple"
  basket, warehouse = add basket, warehouse, "milk"
  basket, warehouse = add basket, warehouse, "butter"
  basket, warehouse = add basket, warehouse, "chocolate"
  basket, warehouse = add basket, warehouse, "soap"
end
# puts "Basket after some pushes" + basket.inspect
# puts "Warehose after buying  some stuff from it " + warehouse.inspect
10.times do
  basket, warehouse = remove basket, warehouse, "apple"
  basket, warehouse = remove basket, warehouse, "soap"
  basket, warehouse = remove basket, warehouse, "sxccxx"
end
# puts "Basket after removing stuff" + basket.inspect
# puts "Warehose after putting  things back " + warehouse.inspect
resit basket