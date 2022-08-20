FactoryBot.define do
  factory :adoption do
    title { "This cute cat needs a home" }
    description  { "I've founded it on side of Beahaus street inside a box." }
    user { create(:user) }
    animal { build(:animal, user: user, status: 2) }
  end
end
