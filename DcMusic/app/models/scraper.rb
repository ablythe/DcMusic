class Scraper
  require 'open-uri'
  def self.scrape_venue venue
    response = Nokogiri::HTML(open(venue.website))
    headliners = Scraper.parse_response(venue.headline_identifier, response)
    support = Scraper.parse_response(venue.support_identifier, response, true)
    {headliners: headliners, support: support}
  end

  def self.parse_response(identifier, response, support=false)
    singer_data = response.css("#{identifier}")
    singers = singer_data.map{|element| element.text}
    return singers unless support
    singers.map{ |singer| singer.split(/[,|]/) }.flatten
  end
end
