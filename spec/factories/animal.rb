FactoryBot.define do
  factory :animal do
    name { "Tunico" }
    age  { "0.11" }
    specie { "Cat" }
    gender { 'Male' }
    size { 'Small' }
    user { create(:user)}
    status { Animal.statuses["in_adoption"] }
  end 
end
