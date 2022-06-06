# frozen_string_literal: true

require 'newton'

describe Newton do
  let(:newton) { 1.newton }
  let(:measurement_unit) { 1.measurement_unit }

  it 'performs ariphmetical operations' do
    expect(newton + 2.newtons).to eq(3.newtons)
    expect(newton - 2.newtons).to eq(-1.newtons)
    expect(newton * 2).to eq(2.newtons)
    expect(newton / 4.0).to eq(0.25.newtons)
  end

  it 'raises in ariphmetics on unexpected types' do
    expect { newton + measurement_unit }.to raise_exception(ArgumentError)
    expect { newton - measurement_unit }.to raise_exception(ArgumentError)
    expect { newton * measurement_unit }.to raise_exception(ArgumentError)
    expect { newton / measurement_unit }.to raise_exception(ArgumentError)
    expect { newton * 'Hello' }.to raise_exception(ArgumentError)
    expect { newton * 1.newton }.to raise_exception(ArgumentError)
    expect { newton / 1.newton }.to raise_exception(ArgumentError)
  end

  it 'can be used as a numeric in some cases' do
    expect(newton.to_f).to eq(1.0.newtons)
  end
end
