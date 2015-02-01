require 'open-uri'

class Post < ActiveRecord::Base
	def self.scrape_pulsd
		listings_page = Nokogiri::HTML(open("http://www.pulsd.com/new-york"))
		listings_array = listings_page.css(".pulse-box a")
		listings_array.each do |listing|
			post_url = "http://www.pulsd.com" + listing.attributes["href"].value
			unless Post.all.pluck(:url).include?(post_url)
				post_page = Nokogiri::HTML(open(post_url))
				if post_page.css("div[style='color: black; font-size: 30px; margin-top: 15px; padding-bottom: 15px; color: #48BC96; margin-left: 15px; letter-spacing: 2px;']").size > 0
					post = Hash.new
					post[:url] = post_url
					post[:venue] = post_page.css(".grid_5 > div > div[style='font-size: 20px; font-weight: bold; letter-spacing: 1px;']").children.first.text[1..-2]
					post[:description] = post_page.css(".grid_5 > div > div[style='font-size: 15px; margin-top: 20px; margin-bottom: 10px; letter-spacing: 1px;']").children.first.text[1..-2]
					post[:address] = post_page.css(".grid_5 > .grey-background.product-text.pjsLinkToNewTab").first.children[2].text[1..-2]
					post[:price] = post_page.css("div[style='color: black; font-size: 30px; margin-top: 15px; padding-bottom: 15px; color: #48BC96; margin-left: 15px; letter-spacing: 2px;']").first.text[1..-3]
					post[:details] = ""
					post_page.css(".grid_9 > .pjsLinkToNewTab").first.children.each_with_index do |child, index|
						post[:details] += "#{child.text} " if index.odd?
					end
					Post.create(post)
				else
					# build this
				end
			end
		end
	end
end


