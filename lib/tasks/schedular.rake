desc "Check Pulsd website for new posts"
task :update_posts => :environment do
  puts Post.scrape_pulsd.to_s + " new posts found."
end