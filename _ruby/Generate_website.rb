require 'io/console'
require 'fileutils'
require 'inifile'

file = IniFile.load(__dir__ + '/Create_Temp_Data.ini')
data = file["Databases"]
exes = file["EXE"]
fils = file["Files"]

Joplin = data["Joplin"]
Shrops = data["Shropshire"]
TempDB = data["Temp"]
SQLite = exes["SQLite"]
DumpFl = fils["Dump"]

# File.delete(TempDB) if File.exist?(TempDB)

cmd = SQLite + " \"" + TempDB + "\" " + "\"DROP TABLE IF EXISTS folders;\"" + " .exit"
system(cmd)
cmd = SQLite + " \"" + TempDB + "\" " + "\"DROP TABLE IF EXISTS notes;\"" + " .exit"
system(cmd)
cmd = SQLite + " \"" + TempDB + "\" " + "\"DROP TABLE IF EXISTS tags;\"" + " .exit"
system(cmd)
cmd = SQLite + " \"" + TempDB + "\" " + "\"DROP TABLE IF EXISTS note_tags;\"" + " .exit"
system(cmd)
cmd = SQLite + " \"" + TempDB + "\" " + "\"DROP TABLE IF EXISTS GoogleMap;\"" + " .exit"
system(cmd)
cmd = SQLite + " \"" + TempDB + "\" " + "\"DROP TABLE IF EXISTS Photo;\"" + " .exit"
system(cmd)
cmd = SQLite + " \"" + TempDB + "\" " + "\"DROP TABLE IF EXISTS SubImage;\"" + " .exit"
system(cmd)

puts 'Dumping folders table from Joplin database...'
txt = ".output " + DumpFl + "\n"\
      ".dump folders\n"\
      ".output\n"\
      ".open " + TempDB + "\n"\
      ".read " + DumpFl + "\n"
File.write(__dir__ + "/Create_Temp_Data.txt", txt)
cmd = SQLite + " \"" + Joplin + "\" < \"" + __dir__ + "/Create_Temp_Data.txt\""
system(cmd)
puts '...done.'

puts 'Dumping notes table from Joplin database...'
txt = ".output " + DumpFl + "\n"\
      ".dump notes\n"\
      ".output\n"\
      ".open " + TempDB + "\n"\
      ".read " + DumpFl + "\n"
File.write(__dir__ + "/Create_Temp_Data.txt", txt)
cmd = SQLite + " \"" + Joplin + "\" < \"" + __dir__ + "/Create_Temp_Data.txt\""
system(cmd)
puts '...done.'

puts 'Dumping tags table from Joplin database...'
txt = ".output " + DumpFl + "\n"\
      ".dump tags\n"\
      ".output\n"\
      ".open " + TempDB + "\n"\
      ".read " + DumpFl + "\n"
File.write(__dir__ + "/Create_Temp_Data.txt", txt)
cmd = SQLite + " \"" + Joplin + "\" < \"" + __dir__ + "/Create_Temp_Data.txt\""
system(cmd)
puts '...done.'

puts 'Dumping note_tags table from Joplin database...'
txt = ".output " + DumpFl + "\n"\
      ".dump note_tags\n"\
      ".output\n"\
      ".open " + TempDB + "\n"\
      ".read " + DumpFl + "\n"
File.write(__dir__ + "/Create_Temp_Data.txt", txt)
cmd = SQLite + " \"" + Joplin + "\" < \"" + __dir__ + "/Create_Temp_Data.txt\""
system(cmd)
puts '...done.'

puts 'Dumping GoogleMap table from Shropshire database...'
txt = ".output " + DumpFl + "\n"\
      ".dump GoogleMap\n"\
      ".output\n"\
      ".open " + TempDB + "\n"\
      ".read " + DumpFl + "\n"
File.write(__dir__ + "/Create_Temp_Data.txt", txt)
cmd = SQLite + " \"" + Shrops + "\" < \"" + __dir__ + "/Create_Temp_Data.txt\""
system(cmd)
puts '...done.'

puts 'Dumping Photo table from Shropshire database...'
txt = ".output " + DumpFl + "\n"\
      ".dump Photo\n"\
      ".output\n"\
      ".open " + TempDB + "\n"\
      ".read " + DumpFl + "\n"
File.write(__dir__ + "/Create_Temp_Data.txt", txt)
cmd = SQLite + " \"" + Shrops + "\" < \"" + __dir__ + "/Create_Temp_Data.txt\""
system(cmd)
puts '...done.'

puts 'Dumping SubImage table from Shropshire database...'
txt = ".output " + DumpFl + "\n"\
      ".dump SubImage\n"\
      ".output\n"\
      ".open " + TempDB + "\n"\
      ".read " + DumpFl + "\n"
File.write(__dir__ + "/Create_Temp_Data.txt", txt)
cmd = SQLite + " \"" + Shrops + "\" < \"" + __dir__ + "/Create_Temp_Data.txt\""
system(cmd)
puts '...done.'

puts "Running SQL script..."
txt = "DELETE FROM exp_churches;\n"
txt = txt + "INSERT INTO exp_churches (name) SELECT name FROM GoogleMap ORDER BY name;\n"
txt = txt + "UPDATE exp_churches SET place = (SELECT place FROM GoogleMap g WHERE g.name = exp_churches.name);\n"
txt = txt + "UPDATE exp_churches SET date = (SELECT TRIM(REPLACE(SUBSTR(body, INSTR(body, '- Date:'), INSTR(body, char(10))-1), '- Date:', '')) FROM notes n WHERE n.title = exp_churches.name);\n"
txt = txt + "UPDATE exp_churches SET dedication = (SELECT dedication1 || COALESCE (' and ' || dedication2, '') FROM GoogleMap g WHERE g.name = exp_churches.name);\n"
txt = txt + "UPDATE exp_churches SET diocese = (SELECT diocese FROM GoogleMap g WHERE g.name = exp_churches.name);\n"
txt = txt + "UPDATE exp_churches SET grade = (SELECT grade FROM GoogleMap g WHERE g.name = exp_churches.name);\n"
txt = txt + "UPDATE exp_churches SET dedication1 = (SELECT dedication1 FROM GoogleMap g WHERE g.name = exp_churches.name);\n"
txt = txt + "UPDATE exp_churches SET dedication2 = (SELECT dedication2 FROM GoogleMap g WHERE g.name = exp_churches.name);\n"
txt = txt + "UPDATE exp_churches SET notes = (SELECT TRIM(REPLACE(SUBSTR(SUBSTR(body, INSTR(body, '## Details')), 1, INSTR(SUBSTR(body, INSTR(body, '## Details')), '* * *')-1), '## Details', ''), char(10)) FROM notes n WHERE n.title = exp_churches.name);\n"
txt = txt + "UPDATE exp_churches SET photo = (SELECT SUBSTR(OrigName, 1, INSTR(OrigName, '.')) || 'jpg' FROM Photo p WHERE p.Church = exp_churches.name);\n"
txt = txt + "UPDATE exp_churches SET subimages_id = (SELECT ID FROM Photo p WHERE p.Church = exp_churches.name);\n"
txt = txt + "UPDATE exp_churches SET note_id = (SELECT id FROM notes n WHERE n.title = exp_churches.name);\n"
txt = txt + "UPDATE exp_churches SET status_no_inside_photo = 0;\n"
txt = txt + "UPDATE exp_churches SET status_no_inside_photo = 1 WHERE note_id IN (SELECT note_id FROM note_tags WHERE tag_id = (SELECT id FROM tags WHERE title = 'revisit status: seen inside but no photos'));\n"
txt = txt + "UPDATE exp_churches SET category = (SELECT Category1 FROM Photo p WHERE p.Church = exp_churches.name);\n"
txt = txt + "UPDATE exp_churches SET status_visited = 0;\n"
txt = txt + "UPDATE exp_churches SET status_visited = 1 WHERE note_id IN (SELECT note_id FROM note_tags WHERE tag_id = (SELECT id FROM tags WHERE title = 'status: visited'));\n"
txt = txt + "UPDATE exp_churches SET status_not_been_inside = 0;\n"
txt = txt + "UPDATE exp_churches SET status_not_been_inside = 1 WHERE note_id IN (SELECT note_id FROM note_tags WHERE tag_id = (SELECT id FROM tags WHERE title = 'revisit status: need to revisit for inside'));\n"
txt = txt + "UPDATE exp_churches SET status_not_been_inside_and_revisit_not_planned = 0;\n"
txt = txt + "UPDATE exp_churches SET status_not_been_inside_and_revisit_not_planned = 1 WHERE note_id IN (SELECT note_id FROM note_tags WHERE tag_id = (SELECT id FROM tags WHERE title = 'revisit status: not planned to revisit'));\n"
txt = txt + "UPDATE exp_churches SET status_visit_planned = 0;\n"
txt = txt + "UPDATE exp_churches SET status_visit_planned = 1 WHERE note_id IN (SELECT note_id FROM note_tags WHERE tag_id = (SELECT id FROM tags WHERE title = 'status: planned to visit'));\n"
txt = txt + "UPDATE exp_churches SET status_visit_planned_priority = 0;\n"
txt = txt + "UPDATE exp_churches SET status_visit_planned_priority = 1 WHERE note_id IN (SELECT note_id FROM note_tags WHERE tag_id = (SELECT id FROM tags WHERE title = 'status: planned to visit - priority'));\n"
txt = txt + "UPDATE exp_churches SET status_not_yet_visited = 0;\n"
txt = txt + "UPDATE exp_churches SET status_not_yet_visited = 1 WHERE note_id IN (SELECT note_id FROM note_tags WHERE tag_id = (SELECT id FROM tags WHERE title = 'status: not yet visited'));\n"
File.write(__dir__ + "/Transform_SQL.sql", txt)
cmd = SQLite + " \"" + TempDB + "\" < \"" + __dir__ + "/Transform_SQL.sql\""
system(cmd)
puts '...done.'

_BaseFolder = 'C:\Users\David\Documents\OneDrive\Documents\My Documents\GitHub\salop'

require _BaseFolder + '\_ruby\generate_recents.rb'
require _BaseFolder + '\_ruby\convert_md_to_yml.rb'
require _BaseFolder + '\_ruby\generate_churches.rb'
require _BaseFolder + '\_ruby\generate_churches_status.rb'
require _BaseFolder + '\_ruby\generate_churches_grade.rb'
require _BaseFolder + '\_ruby\generate_churches_saint.rb'
Dir.chdir(_BaseFolder + '\_ruby') do
    generate_recents()
    generate_churches(TempDB)
    convert_md_to_yml()
    generate_churches_status(TempDB)
    generate_churches_grade(TempDB)
    generate_churches_saint(TempDB)
end

system('jekyll build --verbose --config _config.yml', chdir: _BaseFolder + '\1shropshire\updates')

FileUtils.cp _BaseFolder + '\1shropshire\updates\_site\1-updateslist.html', _BaseFolder + '\_includes', :verbose => true

system('jekyll build --verbose --config _config.yml', chdir: _BaseFolder)

FileUtils.cp _BaseFolder + '\_data\Shropshire_Notebook-Churches_Status.yml', _BaseFolder + '\..\churches\_data', :verbose => true

puts 'Press any key to exit.'
STDIN.getch
