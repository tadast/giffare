task :cron do
  Rake::Task["reddit:front"].invoke
  Rake::Task["reddit:top"].invoke
end