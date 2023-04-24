require 'sqlite3'

def generate_castles(pDBName)

puts "Starting: generate_castles"

db = SQLite3::Database.open pDBName

dstf = "../_data/Shropshire_Notebook-Castles.csv"
dsth = File.open(dstf, "w:UTF-8")
dsth.write("Type,Title,Description,Thumbnail\n")

castles = db.query "SELECT title, body FROM notes n WHERE parent_id = '1debaab3da4449bb9f67eb113238cd1d' ORDER BY title"

castles.each { |castle|
  dsth.write("Item,")
  dsth.write("\"" + castle[0] + "\",")
  dsth.write("\"" + castle[1] + "\",")
  photos = db.query "SELECT OrigName FROM Photo WHERE Category2 = 'Castle' AND Title = '" + castle[0] + "'"
  thumb = ""
  photos.each { |photo|
    thumb = photo[0]
  }
  thumb = File.basename(thumb, ".*") + ".jpg"
  dsth.write("\"" + thumb + "\"\n")
}

dsth.close unless dsth.nil?

puts "Done: generate_castles"

end
