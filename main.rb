# frozen_string_literal: true

require "capybara"
require "capybara/dsl"
require "erb"

Game = Struct.new(:name, :link, :src, :width, :height)

class Scrapper

  include Capybara::DSL

  def list_free_games
    # select URL
    Capybara.app_host = 'https://store.epicgames.com'

    # visit website
    visit("/en-US/free-games")

    # wait until free games are actually loaded in page
    sleep 10

    number_of_free_games = find_all('.css-11xvn05', text: "FREE NOW").count

    imgs = find_all(".css-1lozana img")[..number_of_free_games-1]
    links = find_all(".css-1myhtyb a")[..number_of_free_games-1]

    games = imgs.zip(links).map do |(img, link)|
      Game.new(img[:alt], link[:href], img[:src], img[:width], img[:height])
    end

    template = ERB.new(File.read("templates/email.erb"))
    File.write("email.html", template.result_with_hash(games: games))
  end
end

# configure_capybara
Capybara.default_driver = :selenium_headless
Capybara.run_server = false

# run
Scrapper.new.list_free_games
