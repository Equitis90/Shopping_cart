product_types = [ 'Tea', 'Coffee' ]

product_types.each do | p_type |
  ProductType.create!( title: p_type )
end

tea_id = ProductType.get_type( 'Tea' ).first.id
coffee_id = ProductType.get_type( 'Coffee' ).first.id

products = [ [ 'Black tea', tea_id, 10 ], [ 'Some coffee', coffee_id, 15 ], [ 'Some tea', tea_id, 20 ],
             [ 'Another coffee', coffee_id, 20 ],
             [ 'Another tea', tea_id, 50 ], [ 'Just coffee', coffee_id, 45 ]
]

products.each do | product |
  Product.create!( title: product[0], type_id: product[1], price: product[2] )
end

black_tea_id = Product.where( :title => 'Black tea' ).first.id
discounts = [ [ black_tea_id, nil, 3, true, 20, true ], [ nil, coffee_id, 2, false, 10, false ] ]

discounts.each do | discount |
  Discount.create!( product_id: discount[ 0 ],
    product_type_id: discount[ 1 ], quantity: discount[ 2 ],
    percent: discount[ 3 ], value: discount[ 4 ], active: true, total: discount[ 5 ]
  )
end