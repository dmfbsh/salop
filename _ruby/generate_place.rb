require 'sqlite3'

def generate_place(pDBName, pPlace)

puts "Starting: generate_place " + pPlace

db = SQLite3::Database.open pDBName

parentid = ""
folders = db.query "SELECT id FROM folders WHERE title = 'Town - " + pPlace + "'"
folders.each { |folder|
  parentid = folder[0]
}

dstf = "../_data/Shropshire_Notebook-" + pPlace + ".json"
dsth = File.open(dstf, "w:UTF-8")

dsth.write("[")
dsth.write("{\n")
dsth.write("  \"Type\": \"Header\",\n")
dsth.write("  \"Title\": \"" + pPlace + "\",\n")
info = ""
notes = db.query "SELECT body FROM notes WHERE parent_id = '" + parentid + "' AND title = 'Overview'"
notes.each { |note|
  info = note[0]
}    
dsth.write("  \"Description\": \"" + info + "\"\n")
dsth.write("},\n")

lastplace = "none"
places = db.query "SELECT LatLong, Place, Description, OrigName, Category1 FROM Photo WHERE Name LIKE '" + pPlace + "%' AND (Category1 = 'Place' OR Category1 = 'History') AND Place <> '' ORDER BY Place"
places.each { |place|
  if lastplace != place[1]
    if lastplace != "none"
      dsth.write("   ]\n") unless dsth.nil?
      dsth.write("},\n") unless dsth.nil?
    end
    lastplace = place[1]
    dsth.write("{\n")
    dsth.write("  \"Type\": \"Item\",\n")
    dsth.write("  \"Title\": \"" + place[1] + "\",\n")
    dsth.write("  \"LatLong\": \"" + place[0] + "\",\n")
    info = ""
    notes = db.query "SELECT body FROM notes WHERE parent_id = '" + parentid + "' AND title = '" + place[1] + "'"
    notes.each { |note|
      info = note[0]
    }    
    dsth.write("  \"Description\": \"" + info + "\",\n")
    dsth.write("  \"Thumbnails\": [\n")
  end
  thumb = File.basename(place[3], ".*") + ".jpg"
  if place[4] == "History"
    thumb = "history/" + thumb
  else
    thumb = "places/" + thumb
  end
  dsth.write("    {\n")
  dsth.write("      \"Thumbnail\": \"" + thumb + "\"\n")
  dsth.write("    },\n")
}

if lastplace != "none"
  dsth.write("   ]\n") unless dsth.nil?
  dsth.write("}\n") unless dsth.nil?
end
dsth.write("]")

=begin
dsth.write("- Type: Header\n")
dsth.write("  Title: " + pPlace + "\n")
dsth.write("  Description: |\n")
info = ""
notes = db.query "SELECT body FROM notes WHERE parent_id = '" + parentid + "' AND title = 'Overview'"
notes.each { |note|
  info = note[0]
}    
desc = info.split("\n")
lineidx = 0
desc.each { |txt|
#  txt = txt.tr('\r', '')
  dsth.write("    " + txt + "\n") unless dsth.nil?
  if lineidx < desc.length - 1
    dsth.write("\n") unless dsth.nil?
  end
  lineidx = lineidx + 1
}

lastplace = "none"
places = db.query "SELECT LatLong, Place, Description, OrigName, Category1 FROM Photo WHERE Name LIKE '" + pPlace + "%' AND (Category1 = 'Place' OR Category1 = 'History') AND Place <> '' ORDER BY Place"
places.each { |place|
  if lastplace != place[1]
    if lastplace != "none"
      dsth.write("\n") unless dsth.nil?
    end
    lastplace = place[1]
    dsth.write("- Type: Item\n")
    dsth.write("  Title: " + place[1] + "\n")
    dsth.write("  LatLong: " + place[0] + "\n")
    dsth.write("  Description: |\n")
    info = ""
    notes = db.query "SELECT body FROM notes WHERE parent_id = '" + parentid + "' AND title = '" + place[1] + "'"
    notes.each { |note|
      info = note[0]
    }    
    desc = info.split("\n")
    lineidx = 0
    desc.each { |txt|
#      txt = txt.tr('\r', '')
      dsth.write("    " + txt + "\n") unless dsth.nil?
      if lineidx < desc.length - 1
        dsth.write("\n") unless dsth.nil?
      end
      lineidx = lineidx + 1
    }
    dsth.write("  Thumbnails:\n")
  end
  thumb = File.basename(place[3], ".*") + ".jpg"
  if place[4] == "History"
    thumb = "history/" + thumb
  else
    thumb = "places/" + thumb
  end
  dsth.write("    - Thumbnail: " + thumb + "\n")
}
=end

dsth.close unless dsth.nil?

puts "Done: generate_place " + pPlace

end