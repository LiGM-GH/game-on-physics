# frozen_string_literal: true

require 'newton'

describe Newton do
  let(:newton) { 1.newton }
  let(:measure) { 1.measure }

  it 'performs ariphmetical operations' do
    expect(newton + 2.newtons).to eq(3.newtons)
    expect(newton - 2.newtons).to eq(-1.newtons)
    expect(newton * 2).to eq(2.newtons)
    expect(newton / 4.0).to eq(0.25.newtons)
  end

  it 'raises in ariphmetics on unexpected types' do
    expect { newton + measure }.to raise_exception(ArgumentError)
    expect { newton - measure }.to raise_exception(ArgumentError)
    expect { newton * measure }.to raise_exception(ArgumentError)
    expect { newton / measure }.to raise_exception(ArgumentError)
    expect { newton * 'Hello' }.to raise_exception(ArgumentError)
    expect { newton * 1.newton }.to raise_exception(ArgumentError)
    expect { newton / 1.newton }.to raise_exception(ArgumentError)
  end
end
