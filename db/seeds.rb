product_types = [ 'Tea', 'Coffee' ]

product_types.each do | p_type |
  ProductType.create!( title: p_type )
end

tea_id = ProductType.get_type( 'Tea' ).first.id
coffee_id = ProductType.get_type( 'Coffee' ).first.id

products = [ [ 'Black tea', tea_id ], [ 'Some coffee', coffee_id ], [ 'Some tea', tea_id ],
             [ 'Another coffee', coffee_id ],
             [ 'Another tea', tea_id ], [ 'Just coffee', coffee_id ]
]

products.each do | product |
  Product.create!( title: product[0], type_id: product[1] )
end