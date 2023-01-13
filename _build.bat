C:

CD C:\Users\David\Documents\OneDrive\Documents\My Documents\GitHub\salop\_ruby
ruby generate_recents.rb

ruby convert_md_to_yml.rb

REM CD ..\1shropshire\updates
REM CALL jekyll build --verbose --config _config.yml

COPY _site\1-updateslist.html ..\..\_includes

CD ..\..
jekyll build --verbose --config _config.yml
