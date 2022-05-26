# frozen_string_literal: true

require 'newton'

describe Newton do
  let(:newton) { 1.newton }

  it "has method '+'" do
    expect(newton + 2.newtons).to eq(3.newtons)
  end
end
