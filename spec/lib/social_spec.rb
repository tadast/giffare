require 'spec_helper'

describe Social do
  it "marks gifs as shared after sharing" do
    stub_const("ENV", ENV.to_h.merge('SOCIAL_SHARE' => true))

    gif = Gif.create!(url: "http://trololo.com")
    Social.share(gif)

    expect(gif).to be_shared
  end
end
