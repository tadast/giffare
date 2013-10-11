require 'spec_helper'

describe GifsController do
  describe 'index' do
    it 'works ok' do
      get :index
      response.should be_ok
    end
  end

  describe 'show' do
    it 'works ok' do
      Gif.stub find: Gif.new
      get :show, id: 1
      response.should be_ok
    end
  end

  describe 'create' do
    it 'fails without password' do
      post :create, gif: {title: 'x', url: 'http://google.com'}
      response.status.should eq 401
    end

    it 'is ok with password' do
      user = 'admin'
      pw = 'secret'

      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
      post :create, gif: {title: 'x', url: 'http://google.com'}

      response.should be_ok
    end
  end

  describe 'destroy' do
    it 'fails without password' do
      delete :destroy, id: 1
      response.status.should eq 401
    end

    it 'redirects when with password' do
      Gif.stub find: Gif.new
      user = 'admin'
      pw = 'secret'
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
      delete :destroy, id: 1
      response.should redirect_to(action: :index)
    end
  end
end
