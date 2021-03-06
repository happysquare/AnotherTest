Factory.define :user do |user|
  user.name                     "Andrew2"
  user.email                    "me4@james.com"
  user.password                 "sophie"
  user.password_confirmation    "sophie"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :micropost do |micropost|
  micropost.content  "factory micro post"
  micropost.association  :user
end