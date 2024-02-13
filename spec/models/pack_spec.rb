require 'rails_helper'

RSpec.describe Pack, type: :model do
  let(:pack) { create(:pack) }

  it "belongs to user" do
    expect(pack.user).to be_an_instance_of(User)
  end

  it "is deleted, the associated user remains" do
    user = pack.user
    pack.destroy

    expect { user.reload }.not_to raise_error
  end
end
