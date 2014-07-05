require 'spec_helper'

describe ImgurDirect do
  describe "#resolvable?" do
    it "resolves gallery links" do
      expect(described_class.new('http://imgur.com/gallery/40NpN')).to be_resolvable
    end

    it "resolves album links" do
      expect(described_class.new('http://imgur.com/a/gYZp4')).to be_resolvable
    end

    it "resolves direct links" do
      expect(described_class.new('https://i.imgur.com/neKar7M.gif')).to be_resolvable
    end

    it "resolves indirect links" do
      expect(described_class.new('http://imgur.com/cp3b6Ra')).to be_resolvable
    end

    it "is false for random links" do
      expect(described_class.new('http://google.com')).to_not be_resolvable
    end
  end

  describe "#urls" do
    it "resolves gallery links", :vcr do
      expect(described_class.new('http://imgur.com/gallery/40NpN').urls).to eq %w(http://i.imgur.com/JOCymfx.png http://i.imgur.com/u0sWGjK.png http://i.imgur.com/1cj1Of1.png)
    end

    it "resolves album links", :vcr do
      expect(described_class.new('http://imgur.com/a/gYZp4').urls).to match_array ["http://i.imgur.com/q7f0zNh.gif", "http://i.imgur.com/y0lEyeH.gif", "http://i.imgur.com/fy7liyk.gif", "http://i.imgur.com/KhB46eF.gif", "http://i.imgur.com/0TUJIHT.gif"]
    end

    it "resolves direct links", :vcr do
      expect(described_class.new('https://i.imgur.com/neKar7M.gif').urls).to eq %w(https://i.imgur.com/neKar7M.gif)
    end

    it "resolves indirect links", :vcr do
      expect(described_class.new('http://imgur.com/cp3b6Ra').urls).to eq %w(http://i.imgur.com/cp3b6Ra.gif)
    end

    it "is empty for for non-imgur with no fallback" do
      expect(described_class.new('http://google.com').urls(false)).to eq([])
    end

    it "is the original link for non-imgur links with fallback" do
      expect(described_class.new('http://google.com').urls(:fallback_plz)).to eq %w[http://google.com]
    end
  end

  describe "#strategy", :private do
    it "picks known strategies" do
      expect(described_class.new('https://i.imgur.com/neKar7M.gif').strategy).to eq 'direct_link'
      expect(described_class.new('http://imgur.com/gallery/40NpN').strategy).to  eq 'gallery'
      expect(described_class.new('http://imgur.com/a/gYZp4').strategy).to        eq 'album'
      expect(described_class.new('http://imgur.com/cp3b6Ra').strategy).to        eq 'image'
    end
  end
end
