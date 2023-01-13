#require 'sqlite3'

def convert_md_to_yml()

puts "Starting: convert_md_to_yml"

#db = SQLite3::Database.open pDBName
#ckey = ''

Dir.glob("../_data_source/*.md") do |srcfn|

  srcf = srcfn
  dstf = "../_data/" + srcfn[16..-4] + ".yml"

  puts "Processing: " + srcf
  puts "...to:  " + dstf

  simage = "no"

  dsth = File.open(dstf, "w:UTF-8")

  if dstf.end_with?("History.yml")
  File.readlines(srcf).each do |line|
    if line.start_with?("# Name:")
      dsth.write("- Type: Item\n") unless dsth.nil?
      tmp = "  " + line[2..-1]
      dsth.write(tmp) unless dsth.nil?
    elsif line.start_with?("- Date:")
      tmp = "  " + line[2..-1]
      dsth.write(tmp) unless dsth.nil?
      dsth.write("  Description: |") unless dsth.nil?
    elsif line.start_with?("![](")
      tmp = "  Thumbnail: " + line[line.rindex("/")+1..-3] + line[-1..-1]
      tmp = tmp.gsub("%20", " ")
      dsth.write(tmp) unless dsth.nil?
    elsif line.start_with?("# Header:")
      dsth.write("- Type: Header\n") unless dsth.nil?
      tmp = "  Date:" + line[9..-1]
      dsth.write(tmp) unless dsth.nil?
      dsth.write("  Description: |") unless dsth.nil?
    elsif line.start_with?("# Quote:")
      dsth.write("- Type: Quote\n") unless dsth.nil?
      tmp = "  Name:" + line[8..-1]
      dsth.write(tmp) unless dsth.nil?
      dsth.write("  Description: |") unless dsth.nil?
    else
      tmp = line
      if line.length > 1
        tmp = "    " + tmp
      end
      dsth.write(tmp) unless dsth.nil?
    end
  end
  end
#  if dstf.end_with?("Churches.yml")
#  File.readlines(srcf).each do |line|
#    if line.start_with?("# Name:")
#      dsth.write("- Type: Item\n") unless dsth.nil?
#      tmp = "  " + line[2..-1]
#      dsth.write(tmp) unless dsth.nil?
#      simage = "no"
#      crefs = line[7..-1].split(',', 2)
#      cplace = crefs[1].strip
#      cdedic = crefs[0].strip
#      ckey = cplace + " - " + cdedic
#      puts ckey
#      results = db.query "SELECT grade FROM GoogleMap WHERE name = ?", ckey
#      first_result = results.next
#      if first_result
#        tmp = "  Grade: " + first_result[0] + "\n"
#      else
#        tmp = '  Grade: Not found in database.' + "\n"
#      end
#      dsth.write(tmp) unless dsth.nil?
#    elsif line.start_with?("- Diocese:")
#      tmp = "  " + line[2..-1]
#      dsth.write(tmp) unless dsth.nil?
#    elsif line.start_with?("- Date:")
#      tmp = "  " + line[2..-1]
#      dsth.write(tmp) unless dsth.nil?
#      dsth.write("  Description: |") unless dsth.nil?
#    elsif line.start_with?("![](")
#      tnm = line[line.rindex("/")+1..-3]
#      tnm = tnm.gsub("%20", " ")
#      tmp = "  Thumbnail: " + tnm + line[-1..-1]
#      dsth.write(tmp) unless dsth.nil?
#    elsif line.start_with?("- Sub-Image:")
#      if simage == "no"
#        simage = "yes"
#        dsth.write("  Sub-Images:\n") unless dsth.nil?
#      end
#      tmp = "    - " + line[2..-1]
#      dsth.write(tmp) unless dsth.nil?
#    else
#      tmp = line
#      if line.length > 1
#        tmp = "    " + tmp
#      end
#      dsth.write(tmp) unless dsth.nil?
#    end
#  end
#  end
  if dstf.end_with?("Other.yml")
    File.readlines(srcf).each do |line|
      if line.start_with?("# ")
        dsth.write("- Type: Year\n") unless dsth.nil?
        tmp = "  Year: " + line[2..-1]
        dsth.write(tmp) unless dsth.nil?
      elsif line.start_with?("## Name:")
        dsth.write("- Type: Item\n") unless dsth.nil?
        tmp = "  " + line[3..-1]
        dsth.write(tmp) unless dsth.nil?
        dsth.write("  Description: |") unless dsth.nil?
      elsif line.start_with?("![](")
        tmp = "  Thumbnail: " + line[line.rindex("/")+1..-3] + line[-1..-1]
        tmp = tmp.gsub("%20", " ")
        dsth.write(tmp) unless dsth.nil?
      else
        tmp = line
        if line.length > 1
          tmp = "    " + tmp
        end
        dsth.write(tmp) unless dsth.nil?
      end
    end
  end
  if dstf.end_with?("Castles.yml") || dstf.end_with?("Folklore.yml") || dstf.end_with?("Houses.yml") || dstf.end_with?("People.yml")
    File.readlines(srcf).each do |line|
      if line.start_with?("# Name:")
        dsth.write("- Type: Item\n") unless dsth.nil?
        tmp = "  " + line[2..-1]
        dsth.write(tmp) unless dsth.nil?
        simage = "no"
      elsif line.start_with?("- Date:")
        tmp = "  " + line[2..-1]
        dsth.write(tmp) unless dsth.nil?
        dsth.write("  Description: |") unless dsth.nil?
      elsif line.start_with?("![](")
        tmp = "  Thumbnail: " + line[line.rindex("/")+1..-3] + line[-1..-1]
        tmp = tmp.gsub("%20", " ")
        dsth.write(tmp) unless dsth.nil?
      elsif line.start_with?("- Sub-Image:")
        if simage == "no"
          simage = "yes"
          dsth.write("  Sub-Images:\n") unless dsth.nil?
        end
        tmp = "    - " + line[2..-1]
        dsth.write(tmp) unless dsth.nil?
      else
        tmp = line
        if line.length > 1
          tmp = "    " + tmp
        end
        dsth.write(tmp) unless dsth.nil?
      end
    end
    end
    if dstf.end_with?("Gardens.yml") || dstf.end_with?("Bridgnorth.yml") || dstf.end_with?("Ludlow.yml") || dstf.end_with?("Oswestry.yml") || dstf.end_with?("Telford.yml") || dstf.end_with?("Shrewsbury.yml") || dstf.end_with?("Whitchurch.yml")
  File.readlines(srcf).each do |line|
    if line.start_with?("# Name:")
      dsth.write("- Type: Item\n") unless dsth.nil?
      tmp = "  " + line[2..-1]
      dsth.write(tmp) unless dsth.nil?
      dsth.write("  Description: |") unless dsth.nil?
    elsif line.start_with?("![](")
      tmp = "  Thumbnail: " + line[line.rindex("/")+1..-3] + line[-1..-1]
      tmp = tmp.gsub("%20", " ")
      dsth.write(tmp) unless dsth.nil?
    else
      tmp = line
      if line.length > 1
        tmp = "    " + tmp
      end
      dsth.write(tmp) unless dsth.nil?
    end
  end
  end
  if dstf.end_with?("Landscape.yml")
  File.readlines(srcf).each do |line|
    if line.start_with?("# Intro:")
      dsth.write("- Type: Intro\n") unless dsth.nil?
      tmp = "  " + line[2..-1]
      dsth.write(tmp) unless dsth.nil?
      dsth.write("  Description: |") unless dsth.nil?
	elsif line.start_with?("# Name:")
      dsth.write("- Type: Item\n") unless dsth.nil?
      tmp = "  " + line[2..-1]
      dsth.write(tmp) unless dsth.nil?
      dsth.write("  Description: |") unless dsth.nil?
    elsif line.start_with?("![](")
      tmp = "  Thumbnail: " + line[line.rindex("/")+1..-3] + line[-1..-1]
      tmp = tmp.gsub("%20", " ")
      dsth.write(tmp) unless dsth.nil?
    else
      tmp = line
      if line.length > 1
        tmp = "    " + tmp
      end
      dsth.write(tmp) unless dsth.nil?
    end
  end
  end

  dsth.close unless dsth.nil?

end

puts "Done: convert_md_to_yml"

end

convert_md_to_yml()
