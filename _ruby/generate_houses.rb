require 'sqlite3'

def generate_houses(pDBName)

puts "Starting: generate_houses"

db = SQLite3::Database.open pDBName

dstf = "../_data/Shropshire_Notebook-Houses.csv"
dsth = File.open(dstf, "w:UTF-8")
dsth.write("Type,Title,Description,Thumbnail\n")

houses = db.query "SELECT title, body FROM notes n WHERE parent_id = '07e0eea7dc624bd99238430477f6939c' ORDER BY title"

houses.each { |house|
  dsth.write("Item,")
  dsth.write("\"" + house[0] + "\",")
  dsth.write("\"" + house[1] + "\",")
  photos = db.query "SELECT OrigName FROM Photo WHERE Category2 = 'House' AND Title = '" + house[0] + "'"
  thumb = ""
  photos.each { |photo|
    thumb = photo[0]
  }
  thumb = File.basename(thumb, ".*") + ".jpg"
  dsth.write("\"" + thumb + "\"\n")
}

dsth.close unless dsth.nil?

puts "Done: generate_houses"

end
