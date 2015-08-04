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