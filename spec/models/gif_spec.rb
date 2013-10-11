require 'spec_helper'

describe Gif do
  describe "#directified_url" do
    it 'converts imgur page urls to direct urls' do
      gif = Gif.new url: 'http://imgur.com/JvAod'
      gif.directified_url.should eq 'http://i.imgur.com/JvAod.gif'
    end

    it 'does nothing to direct urls' do
      gif = Gif.new url: 'http://i.imgur.com/JvAod.gif'
      gif.directified_url.should eq 'http://i.imgur.com/JvAod.gif'
    end

    it 'does nothing to non imgur urls' do
      gif = Gif.new url: 'http://trololo.com/JvAod.gif'
      gif.directified_url.should eq 'http://trololo.com/JvAod.gif'
    end
  end
end
