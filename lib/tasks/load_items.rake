desc "Load Items"
task :load_items => :environment do

  Posting.delete_all
  Category.delete_all
  User.delete_all

  cats = ["antiques",
  "appliances",
  "arts+crafts",
  "atv/utv/sno",
  "auto parts",
  "beauty+hlth",
  "bikes",
  "boats",
  "books",
  "cars+trucks",
  "cds/dvd/vhs",
  "cell phones",
  "clothes+acc",
  "computers",
  "electronics",
  "farm+garden",
  "furniture",
  "heavy equip",
  "household",
  "jewelry",
  "motorcycles",
  "music instr",
  "photo+video",
  "rvs+camp",
  "sporting",
  "tools",
  "toys+games",
  "video gaming"]

  users = []
  10.times do |i|
    u = User.new
    u.email = "user_#{i}@foo.com"
    u.password = "foobarbaz"
    u.admin = true
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
      new_item.street = "3808 Ray St."
      new_item.city = "San Diego"
      new_item.zip = "92104"
      new_item.user = users[(rand() * 10).floor]
      new_item.save
    end

  end

end
