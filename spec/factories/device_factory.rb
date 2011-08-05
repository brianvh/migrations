FactoryGirl.define do
  factory :computer do
    vendor 'HP'
    kind 'Desktop'
  end
  
  factory :mobile do
    vendor 'Apple'
    kind 'iPhone'
  end
end