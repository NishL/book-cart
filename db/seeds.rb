# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Product.delete_all # This was left out the first time in order to keep what I typed in by hand using the web form.

Product.create!(title: 'Seven mobile apps in seven weeks',
  description:
    %{<p>
      <em>Native Apps, Multiple Platforms.</em>
      Answer the question "Can we build this for ALL the devices?" with 
      a ressounding YES.
      </p>},
  image_url: '7apps.jpg',
  price: 26.00)
