Jbuilder.encode do |json|
  json.id @product_types[ :id ]
  json.title @product_types[ :title ]
end