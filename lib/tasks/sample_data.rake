require 'faker'

namespace :db do
  desc "Fill db with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_microposts
    make_relationships
  end
   
  def make_users 
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
  def make_microposts
    User.all(:limit => 6).each do |user|
      50.times do
        user.microposts.create!(:content => Faker::Lorem.sentence(5))
      end
    end
  end
  
  def make_relationships 
    users = User.all
    user = User.first
    following = users[1..50]
    followers = users[3..40]
    following.each{|f| user.follow!(f)}
    followers.each{|f| f.follow!(user)}
  end
  
end
      