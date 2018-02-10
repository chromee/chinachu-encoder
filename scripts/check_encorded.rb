require 'json'
require 'open3'
require './chinachu_utils'
include ChinachuUtils

# エンコードされてないtsファイル名を標準出力するだけ
def check()
  recorded = File.expand_path("../../recorded/recorded20180209.json", __FILE__)
  File.open(recorded, "r") do |f|
    animes = JSON.load(f)
    animes.each do |anime|
      next if encorded? anime
      puts anime["recorded"]
      puts anime
    end
  end
end

# エンコードされてないtsファイルをエンコードする
def bulk_encode()
  recorded = File.expand_path("../../recorded/recorded20180209.json", __FILE__)
  File.open(recorded, "r") do |f|
    animes = JSON.load(f)
    animes.each do |anime|
      next if encorded? anime
        output, error = "", ""
      cmd = "ruby -W0 encoder.rb '#{anime["recorded"]}' '#{anime}'"
      Open3.popen3(cmd) do |stdin, stdout, stderr, thread|
        stdout.each {|line| output << line }
        stderr.each {|line| error << line }
      end
      puts output
      puts error
    end
  end
end

bulk_encode
