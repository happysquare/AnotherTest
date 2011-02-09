require 'faker'

namespace :db do
  desc "Fill db with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!( :name => "james johnston",
                  :email=>"james@happysquare.com.au",
                  :password => "soph22", 
                  :password_confirmation => "soph22",
                  )
                  admin.toggle!(:admin)
    
    99.times do |n|
      name  = Faker::Name.name
      email = "user_#{n}@test.com"
      password = "password"
      User.create!(:name => name,
                    :email => email,
                    :password =>password,
                    :password_confirmation => password)
    end
  end
end
      