require 'json'
require './chinachu_utils'
include ChinachuUtils

def main()
  File.open("/home/shaka/chinachu-encorder/recorded/recorded20180209.json", "r") do |f|
    animes = JSON.load(f)
    animes.each do |anime|
      next if encorded? anime
      puts anime["recorded"]
      puts anime_path(anime)
    end
  end
end

main
