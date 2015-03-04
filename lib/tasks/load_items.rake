desc "Load Items"
task :load_items => :environment do

  Posting.delete_all
  Category.delete_all

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
      new_item.save
    end

  end

end
