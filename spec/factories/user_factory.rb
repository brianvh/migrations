FactoryGirl.define do
  factory :admin do
    sequence :uid do |n|
      10 + n
    end
    firstname 'Joe'
    initials 'J.'
    lastname 'Admin'
    name { "#{firstname} #{initials} #{lastname}" }
    deptclass 'Admin Group'
    type 'Admin'
  end

  factory :webmaster do
    sequence :uid do |n|
      20 + n
    end
    firstname 'Joe'
    initials 'J.'
    lastname 'Webmaster'
    name { "#{firstname} #{initials} #{lastname}" }
    deptclass 'Webmaster Group'
    type 'Webmaster'
  end

  factory :client do
    sequence :uid do |n|
      100 + n
    end
    firstname 'Joe'
    initials 'J.'
    lastname 'Client'
    name { "#{firstname} #{initials} #{lastname}" }
    deptclass 'Test Group'
    type 'Client'
  end

  factory :support do
    sequence :uid do |n|
      200 + n
    end
    firstname 'Joe'
    initials 'J.'
    lastname 'Support'
    name { "#{firstname} #{initials} #{lastname}" }
    deptclass 'Support Group'
    type 'Support'
  end

end
