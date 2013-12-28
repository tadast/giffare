require 'spec_helper'

module MinistryOfGif
  describe Fetch do
    it "fetches up to 5 gifs if limited", :vcr do
      expect(RedirectResolver).to receive(:process).exactly(5).times.and_return('url')
      result = Fetch.new(limit: 5, resolve_redirects: true).recent
      expect(result.size).to eq 5
    end

    it "fetches up to 10 and does not resolve redirects", :vcr do
      expect(RedirectResolver).to_not receive(:process)
      result = Fetch.new(limit: 10, resolve_redirects: false).recent
      expect(result.size).to eq 10
    end
  end
end
