desc "Load Items"
task :load_items => :environment do

  Posting.delete_all
  Category.delete_all
  User.delete_all

  cats = ["Antiques",
  "Appliances",
  "Arts & Crafts",
  "ATV/UTV/Sno",
  "Beauty & Health",
  "Bikes",
  "Boats",
  "Books",
  "Cameras & Accessories",
  "Camping",
  "Clothes & Accessories",
  "Computers",
  "DVDs+BluRays",
  "Electronics",
  "Farm & Garden",
  "Furniture",
  "Heavy Equipment",
  "Household",
  "Jewelry",
  "Motor Vehicles",
  "Musical Instruments",
  "RVs",
  "Sports",
  "Tools",
  "Toys & Games",
  "Video Games"]

  users = []
  10.times do |i|
    u = User.new
    u.email = "user_#{i}@foo.com"
    u.password = "foobarbaz"
    u.save
    users.push u
  end

  cats.each do |cat|
    new_cat = Category.new
    new_cat.name = cat
    new_cat.save

    10.times do |x|
      new_item = Posting.new(:category_id => new_cat.id)
      new_item.title = new_cat.name + ' ' + x.to_s
      new_item.description = new_cat.name + ' ' + x.to_s
      new_item.rate = 100
      new_item.street = "123 Main St."
      new_item.user = users[(rand() * 10).floor]
      new_item.save
    end

  end

end
