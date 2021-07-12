offices = Office.create!([
  { city: "London", country: "United Kingdom", address_1: "97 Crown Street", address_2: "", phone: "077 3677 3986", url: "https://www.example.co.uk" },
  { city: "San Francisco", country: "United States", address_1: "3617 Delaware Avenue", address_2: "", phone: "415-335-2512", url: "https://www.example.com" },
  { city: "New York", country: "United States", address_1: "2442 Geneva Street", address_2: "", phone: "917-437-9093", url: "https://www.example.com" },
  { city: "Sydney", country: "Australia", address_1: "79 Ocean Street", address_2: "", phone: "(02) 8595 0018", url: "https://www.example.com.au" },
  { city: "Auckland", country: "New Zealand", address_1: "278 Steele Street", address_2: "", phone: "(021) 2545-544", url: "https://www.example.co.nz" },
  { city: "Singapore", country: "Singapore", address_1: "155 North Bridge Road", address_2: "#26-01 Peninsula Plaza", phone: "65-6336 4010", url: "https://www.example.sg" }
])

users = 100.times do
  User.create!({
    email: Faker::Internet.email,
    password: Faker::Internet.password,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    date_of_birth: Faker::Date.between(from: 60.years.ago, to: 17.years.ago),
    avatar_type: %w(mp identicon monsterid wavatar retro robohash blank).sample,
    time_zone: ActiveSupport::TimeZone::MAPPING.key(Faker::Address.time_zone),
    office: offices.sample
  })
end

categories = Category.create!([
  { name: "Arts", color: Faker::Color.hex_color },
  { name: "Automotive", color: Faker::Color.hex_color },
  { name: "Business", color: Faker::Color.hex_color },
  { name: "Community", color: Faker::Color.hex_color },
  { name: "Economics", color: Faker::Color.hex_color },
  { name: "Entertainment", color: Faker::Color.hex_color },
  { name: "Lifestyle", color: Faker::Color.hex_color },
  { name: "Sport", color: Faker::Color.hex_color },
  { name: "Technology", color: Faker::Color.hex_color },
  { name: "Travel", color: Faker::Color.hex_color }
])
