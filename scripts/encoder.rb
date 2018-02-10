require 'json'
require './chinachu_utils'
include ChinachuUtils

def main
  execute ARGV[0], JSON.parse(ARGV[1])
end

main
