Jbuilder.encode do |json|
  json.id @product[ :id ]
  json.title @product[ :title ]
  json.price @product[ :price ]
  json.product_type_id @product[ :product_type_id ]
  json.active @product[ :active ]
end