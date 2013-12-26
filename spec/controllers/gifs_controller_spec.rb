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
end
