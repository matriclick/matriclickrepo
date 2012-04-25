# Write cron jobs in ruby
every 1.day, :at => '5:00 am' do
  runner "MatriReminder.activity_reminder_email"
	runner "MatriReminder.review_after_wedding_email"
end

every 1.day, :at => '4:00 am' do
  rake "-s sitemap:refresh"
end
