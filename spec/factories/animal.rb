FactoryBot.define do
  factory :animal do
    name { "Tunico" }
    age  { "0.11" }
    specie { "Cat" }
    gender { 'Male' }
    size { 'Small' }
    user { create(:user)}
    status { 0 }
  end 
end
