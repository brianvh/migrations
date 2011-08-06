FactoryGirl.define do
  
  factory :device do
    vendor 'Apple'
    kind 'Laptop'
  end
  
  factory :computer do
    vendor 'HP'
    kind 'Desktop'
  end
  
  factory :mobile do
    vendor 'Apple'
    kind 'iPhone'
  end
end