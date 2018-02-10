require 'json'
require 'open3'
require './chinachu_utils'
include ChinachuUtils

# エンコードされてないtsファイル名を標準出力するだけ
def check()
  recorded_animes.each do |anime|
    next if encorded? anime
    puts anime["recorded"]
    puts anime
  end
end

# エンコードされてないtsファイルをエンコードする
def bulk_encode()
  recorded_animes.each do |anime|
    next if encorded? anime
    execute anime["recorded"], anime, "libfaac"
  end
end

bulk_encode

# nohup ruby -W0 check_encoded.rb &
