# I use this to make life easier when installing and testing from source:
rm -rf csv_pirate-*.gem && gem build csv_pirate.gemspec && sudo gem uninstall csv_pirate && sudo gem install csv_pirate-2.0.0.gem --no-ri --no-rdoc
