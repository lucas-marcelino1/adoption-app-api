FactoryBot.define do
  factory :address do
    city { "Blumenau" }
    state  { "Santa Catarina" }
    zipcode { "89026-444" }
    details { 'Rua Dr. Antonio Hafner, 540' }
  end
end
