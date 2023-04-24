require 'sqlite3'

def generate_folklore(pDBName)

puts "Starting: generate_folklore"

db = SQLite3::Database.open pDBName

dstf = "../_data/Shropshire_Notebook-Folklore.csv"
dsth = File.open(dstf, "w:UTF-8")
dsth.write("Type,Title,Description,Thumbnail\n")

folklores = db.query "SELECT title, body FROM notes n WHERE parent_id = '59f04f1153004c91a26d03984c884a24' ORDER BY title"

folklores.each { |folklore|
  dsth.write("Item,")
  dsth.write("\"" + folklore[0] + "\",")
  dsth.write("\"" + folklore[1] + "\",")
  photos = db.query "SELECT OrigName FROM Photo WHERE Category2 = 'Folklore' AND Title = '" + folklore[0] + "'"
  thumb = ""
  photos.each { |photo|
    thumb = photo[0]
  }
  thumb = File.basename(thumb, ".*") + ".jpg"
  dsth.write("\"" + thumb + "\"\n")
}

dsth.close unless dsth.nil?

puts "Done: generate_folklore"

end
