desc "This task is called by the Heroku scheduler add-on"
task :mic_daily_split => :environment do
  Mic.daily_split_query
end


