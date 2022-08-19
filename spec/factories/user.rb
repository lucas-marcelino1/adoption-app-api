FactoryBot.define do
  factory :user do
    name { "User Name" }
    email  { "user@email.com" }
    password { "123456" }
    registration_number { '111.554.544-44' }
    address { build(:address)}
  end
end