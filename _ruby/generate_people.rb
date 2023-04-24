require 'sqlite3'

def generate_people(pDBName)

puts "Starting: generate_people"

db = SQLite3::Database.open pDBName

dstf = "../_data/Shropshire_Notebook-People.csv"
dsth = File.open(dstf, "w:UTF-8")
dsth.write("Type,Title,Description,Thumbnail\n")

people = db.query "SELECT title, body FROM notes n WHERE parent_id = 'eee7accc17ee4cd199918ba517207448' ORDER BY title"

people.each { |person|
  dsth.write("Item,")
  dsth.write("\"" + person[0] + "\",")
  dsth.write("\"" + person[1] + "\",")
  photos = db.query "SELECT OrigName FROM Photo WHERE Category2 = 'People' AND Title = '" + person[0] + "'"
  thumb = ""
  photos.each { |photo|
    thumb = photo[0]
  }
  thumb = File.basename(thumb, ".*") + ".jpg"
  dsth.write("\"" + thumb + "\"\n")
}

dsth.close unless dsth.nil?

puts "Done: generate_people"

end
