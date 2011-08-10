FactoryGirl.define do

  factory :email_client_choice do
    value "Foo"
    sort_order 0
  end
  
  factory :device_vendor_choice do
    value "Apple"
    sort_order 0
  end
  
  factory :device_kind_choice do
    value "Laptop"
    sort_order 0
  end

  factory :device_mobile_vendor_choice do
    value "Apple"
    sort_order 0
  end
  
  factory :device_mobile_kind_choice do
    value "Phone"
    sort_order 0
  end
  
end