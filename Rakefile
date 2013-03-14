require 'colorize'

task :default => [:yesod]

task :yesod do
  sh %{ yesod --dev devel }
end

task :db_restore_dev do
  puts ">> Dropping YesodExample database and restoring test data <<".yellow
  sh %{ mongorestore --drop ./database/test }
end

task :db_dump_test do
  puts ">> Dumping YesodExample database to /database/test <<".yellow
  sh %{ mongodump --db YesodExample ./database/test/ }
end

task :db_restore_test do
  puts ">> Dropping YesodExample_test database and restoring test data <<".yellow
  sh %{ mongorestore --db YesodExample_test --drop ./database/test/dump/YesodExample/ }
end

task :rebuild do
  sh %{ cabal-dev clean && cabal-dev configure && cabal-dev build }
end

task :start_test_server => [:rebuild] do
  sh %{ ./dist/build/YesodExample/YesodExample Testing }
end

task :test do
  sh %{ casperjs test ./casper/ }
end

task :full_test => [:db_restore_test, :rebuild] do
  Rake::Task["test"].execute
end
