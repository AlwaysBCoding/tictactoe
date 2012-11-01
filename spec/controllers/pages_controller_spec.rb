require 'spec_helper'

describe PagesController do

  describe "GET 'board'" do
    it "returns http success" do
      get 'board'
      response.should be_success
    end
  end

end
