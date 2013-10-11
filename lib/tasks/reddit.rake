require 'rest-client'
require 'json'
require 'reddit'


namespace :reddit do
  desc "Imports gifs from reddit top page"
  task top: :environment do
    count = Gif.count
    Gif.create Reddit.new('gifs').top
    puts "#{Gif.count - count} gifs added."
  end

  desc "Imports gifs from reddit front page"
  task front: :environment do
    count = Gif.count
    Gif.create Reddit.new('gifs').front
    puts "#{Gif.count - count} gifs added."
  end
end