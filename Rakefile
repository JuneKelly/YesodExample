task :default => [:yesod]

task :yesod do
  sh %{ yesod --dev devel }
end

task :drop_and_recreate do
  sh %{ mongorestore --drop ./database/test }
end

task :test do
  sh %{ casperjs test ./casper/ }
end