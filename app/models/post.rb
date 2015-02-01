require 'open-uri'

class Post < ActiveRecord::Base
	def self.scrape_pulsd
		# Without ids, scraping is based on direct children and styles
		counter = 0
		listings_page = Nokogiri::HTML(open("http://www.pulsd.com/new-york"))
		listings_array = listings_page.css(".pulse-box a")
		existing_urls = Post.all.pluck(:url)
		listings_array.each do |listing|
			post_url = "http://www.pulsd.com" + listing.attributes["href"].value
			unless existing_urls.include?(post_url)
				post_page = Nokogiri::HTML(open(post_url))
				post = Hash.new
				post[:url] = post_url
				if post_page.css(".grid_5").size > 0
					post[:venue] = post_page.css(".grid_5 > div > div[style='font-size: 20px; font-weight: bold; letter-spacing: 1px;']").children.first.text[1..-2]
					post[:description] = post_page.css(".grid_5 > div > div[style='font-size: 15px; margin-top: 20px; margin-bottom: 10px; letter-spacing: 1px;']").children.first.text[1..-2]
					post[:address] = post_page.css(".grid_5 > .grey-background.product-text.pjsLinkToNewTab").first.children[2].text[1..-2]
					if post_page.css("div[style='color: black; font-size: 30px; font-weight: 200; margin-top: 15px; padding-bottom: 15px;']").size > 0
						post[:price] = post_page.css("div[style='color: black; font-size: 30px; font-weight: 200; margin-top: 15px; padding-bottom: 15px;']").first.text[1..-3]
					elsif post_page.css("div[style='color: black; font-size: 30px; margin-top: 15px; padding-bottom: 15px; color: #48BC96; margin-left: 15px; letter-spacing: 2px;']").size > 0
						post[:price] = post_page.css("div[style='color: black; font-size: 30px; margin-top: 15px; padding-bottom: 15px; color: #48BC96; margin-left: 15px; letter-spacing: 2px;']").first.text[1..-3]
					end
					post[:details] = ""
					post_page.css(".grid_9 > .pjsLinkToNewTab").first.children.each_with_index do |child, index|
						post[:details] += "#{child.text} " if index.odd?
					end
				else
					post[:venue] = post_page.css(".grid_7 > div > div > div[style='float: left;']").text[1..-2]
					post[:price] = "Free"
					post[:description] = post_page.css(".grid_7 > div > div[style='font-size: 15px; margin-bottom: 20px;']").text[1..-2]
					end_address_index = post_page.css(".grid_7 > div > div[style='font-size: 14px']").text[2..-1].index("\n") + 1
					post[:address] = post_page.css(".grid_7 > div > div[style='font-size: 14px']").text[2..end_address_index]
					post[:details] = post_page.css(".grid_14 > div > .pjsLinkToNewTab > p").text
				end
				Post.create(post)
				counter += 1
			end
		end
		counter
	end
end