require 'sqlite3'

def generate_gardens(pDBName)

puts "Starting: generate_gardens"

db = SQLite3::Database.open pDBName

dstf = "../_data/Shropshire_Notebook-Gardens.csv"
dsth = File.open(dstf, "w:UTF-8")
dsth.write("Type,Title,Description,Thumbnail\n")

gardens = db.query "SELECT title, body FROM notes n WHERE parent_id = '6f6c94c941d74f81a99042d6d0a3ef0e' ORDER BY title"

gardens.each { |garden|
  dsth.write("Item,")
  dsth.write("\"" + garden[0] + "\",")
  dsth.write("\"" + garden[1] + "\",")
  photos = db.query "SELECT OrigName FROM Photo WHERE Category1 = 'Garden' AND Title = '" + garden[0] + "'"
  thumb = ""
  photos.each { |photo|
    thumb = photo[0]
  }
  thumb = File.basename(thumb, ".*") + ".jpg"
  dsth.write("\"" + thumb + "\"\n")
}

dsth.close unless dsth.nil?

puts "Done: generate_gardens"

end
