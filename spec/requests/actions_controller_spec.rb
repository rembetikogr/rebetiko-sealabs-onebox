require 'rails_helper'

describe SealabsOnebox::ActionsController do
  before do
    Jobs.run_immediately!
  end

  it 'can list' do
    sign_in(Fabricate(:user))
    get "/sealabs-onebox/list.json"
    expect(response.status).to eq(200)
  end
end
