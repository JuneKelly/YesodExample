require 'colorize'

task :default => [:yesod]

task :yesod do
  sh %{ yesod --dev devel }
end

task :restore_test do
  puts ">> Dropping YesodExample database and restoring test data <<".yellow
  sh %{ mongorestore --drop ./database/test }
end

task :dump_test do
  puts ">> Dumping YesodExample database to /database/test <<".yellow
  sh %{ mongodump --db YesodExample --out ./database/test/dump/ }
end

task :test do
  sh %{ casperjs test ./casper/ }
end
