require 'rails_helper'

RSpec.describe User, type: :model do
  it "factoryが有効であること" do
    user = build(:user)
    expect(user).to be_valid
  end
end
