require 'bank'

describe Bank do
  subject (:bank) { described_class.new }

  it 'has an initial balance of 0' do
    expect(bank.balance).to eq 0
  end
end
