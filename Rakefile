require 'colorize'

task :default => [:yesod]

task :yesod do
  sh %{ yesod --dev devel }
end

task :drop_and_recreate do
  puts ">> Dropping YesodExample database and restoring test data <<".yellow
  sh %{ mongorestore --drop ./database/test }
end

task :test do
  sh %{ casperjs test ./casper/ }
end