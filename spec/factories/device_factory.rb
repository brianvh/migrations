FactoryGirl.define do
  
  factory :device do
    vendor 'HP'
    kind 'Desktop'
    type 'Computer'
  end

  factory :computer do
    vendor 'Lenovo'
    kind 'Laptop'
  end
  
  factory :mobile do
    vendor 'Apple'
    kind 'Phone'
  end
end