FactoryGirl.define do
  factory :admin do
    uid 10
    firstname 'Joe'
    initials 'J.'
    lastname 'Admin'
    name { "#{firstname} #{initials} #{lastname}" }
    deptclass 'Admin Group'
    type 'Admin'
  end

  factory :webmaster do
    uid 20
    firstname 'Joe'
    initials 'J.'
    lastname 'Webmaster'
    name { "#{firstname} #{initials} #{lastname}" }
    deptclass 'Webmaster Group'
    type 'Webmaster'
  end

  factory :client do
    uid 101
    firstname 'Joe'
    initials 'J.'
    lastname 'Client'
    name { "#{firstname} #{initials} #{lastname}" }
    deptclass 'Test Group'
    type 'Client'
  end

  factory :support do
    uid 201
    firstname 'Joe'
    initials 'J.'
    lastname 'Support'
    name { "#{firstname} #{initials} #{lastname}" }
    deptclass 'Support Group'
    type 'Support'
  end

end
