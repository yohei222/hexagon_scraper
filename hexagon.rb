require 'selenium-webdriver'
require 'pry'
require 'csv'

bom = %w(EF BB BF).map { |e| e.hex.chr }.join
csv_file = CSV.generate(bom) do |csv|
  csv << ["No", "Title", "URL"]
end

File.open("result.csv", "w") do |file|
  file.write(csv_file)
end

d = Selenium::WebDriver.for :chrome

d.get("https://www.hexagonhq.com/releases")

urls = []
d.find_elements(:class, 'margin-wrapper').each do |mw|
  urls << mw.find_element(:tag_name, 'a').attribute("href")
end

i = 1
urls.each do |url|
  d.get(url)
  title = d.title
  CSV.open("result.csv", "a") do |file|
    file << [i, title, url]
  end
  i += 1
end