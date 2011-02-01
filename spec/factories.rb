Factory.define :user do |user|
  user.name                     "David Silver"
  user.email                    "dsilver829@aol.com"
  user.password                 "foobar"
  user.password_confirmation    "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end