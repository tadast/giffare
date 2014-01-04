require 'spec_helper'

describe UnpublishedGifsController do
  def authorize
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('admin','secret')
  end

  describe 'create' do
    it 'fails without password' do
      post :create, gif: {title: 'x', url: 'http://google.com'}
      response.status.should eq 401
    end

    it 'is ok with password' do
      authorize

      post :create, gif: {title: 'x', url: 'http://google.com'}

      response.should be_redirect
    end
  end

  describe 'update' do
    it "does not share on social networks if the checkbox is unticked" do
      authorize
      gif = Gif.create!(url: 'http://google.com')
      expect(Social).to_not receive(:share)

      put :update, id: gif.id, gif: {social_share: "0", url: "http://google.lt"}

      expect(response).to redirect_to(gif_url(gif))
      expect(Gif.last.url).to eq "http://google.lt"
    end

    it "shares on social networks if the checkbox is ticked" do
      authorize
      gif = Gif.create!(url: 'http://google.com')
      expect(Social).to receive(:share)

      put :update, id: gif.id, gif: {social_share: "1", url: "http://google.lt"}

      expect(response).to redirect_to(gif_url(gif))
      expect(Gif.last.url).to eq "http://google.lt"
    end

  end

  describe 'destroy' do
    it 'fails without password' do
      delete :destroy, id: 1
      response.status.should eq 401
    end

    it 'redirects when with password' do
      authorize
      Gif.stub find: Gif.new
      delete :destroy, id: 1
      response.should redirect_to(root_url)
    end
  end
end
