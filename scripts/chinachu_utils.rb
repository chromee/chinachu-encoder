require 'date'
require 'open3'
require 'pathname'
require 'fileutils'

module ChinachuUtils

  def execute(ts_path, anime)
    log_txt = File.expand_path("../../enc-log.txt", __FILE__)
    mp4_path = anime_path!(anime)

    File.open(log_txt, "a") do |f|
      start_time = DateTime.now

      output, error = encode(ts_path, mp4_path)

      end_time = DateTime.now
      diff = (end_time - start_time).to_i
      f.puts "----------start encoding @#{start_time.strftime("%Y/%m/%d %H:%M:%S")}----------"
      f.puts "-----ffmpeg stdout-----"
      f.puts output
      f.puts "-----ffmpeg error-----"
      f.puts error
      f.puts ""
      f.puts "about #{(diff / 60).round} min."
      f.puts "----------finish encoding @#{end_time.strftime("%Y/%m/%d %H:%M:%S")}----------"
      5.times {|i| f.puts ""}
    end
  end

  def encode(ts_path, mp4_path)
    output = ""
    error = ""
    cmd = "ffmpeg -y -i #{ts_path} -vcodec libx264 -acodec aac -tune animation #{mp4_path} 2>&1 | grep '^[^f]'"
    Open3.popen3(cmd) do |stdin, stdout, stderr, thread|
      stdout.each {|line| output << line }
      stderr.each {|line| error << line }
    end
    return output, error
  end

  def encorded?(anime)
    return false unless File.exist? anime_path(anime)
    true
  end

  def anime_path(anime)
    dir = anime_dir(anime)
    title = safe_title(anime["title"])
    episode = anime["episode"] || parse_datetime(anime["start"])
    file_name = "#{title}_#{episode}.mp4"
    return dir.join(file_name).to_s
  end

  # ディレクトリがなければ作成する
  def anime_path!(anime)
    dir = anime_dir(anime)
    FileUtils.mkdir_p(anime_dir.to_s) unless Dir.exist?(anime_dir.to_s)
    title = safe_title(anime["title"])
    episode = anime["episode"] || parse_datetime(anime["start"])
    file_name = "#{title}_#{episode}話.mp4"
    return dir.join(file_name).to_s
  end

  def anime_dir(anime)
    dir = Pathname.new("/storage/mp4/")
    dir = dir.join(Date.today.year.to_s).join(current_season)
    dir = dir.join("再放送") if anime["flags"].include?("再")
    title = safe_title(anime["title"])
    dir = dir.join(title)
    return dir  #Pathnameオブジェクトを返す
  end

  def safe_title(title)
    return title.gsub(/Fate\//, "Fate／")
  end

  def current_season
    month = Date.today.month
    if 1 <= month && month < 4
      season="冬"
    elsif 4 <= month && month < 7
      season="春"
    elsif 7 <= month && month < 10
      season="夏"
    elsif 10 <= month && month <= 12
      season="秋"
    end
    return season
  end

  def parse_datetime(start)
    # JSのDateから生成された整数をTimeオブジェクトに変換
    time = Time.at start.to_i / 1000
    return time.strftime("%Y%m%d")
  end

  def file_count(dir)
    dir = Dir.open(dir)
    count = dir.to_a.reject  {|d| [".", ".."].include?(d) }.count
    dir.close
    return count
  end
end
