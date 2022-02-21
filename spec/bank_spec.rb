require 'bank'

describe Bank do
  subject (:bank) { described_class.new }

  it 'has an initial balance of 0' do
    expect(bank.balance).to eq 0
  end

  describe '#deposit' do
    context 'before the first deposit' do
      it 'set the balance equal to the deposit' do
        bank.deposit(1000)

        expect(bank.balance).to eq 1000
      end
    end

    context 'after an initial deposit has been made' do
      it 'adds to the balance' do
        bank.deposit(1000)
        bank.deposit(2000)

        expect(bank.balance).to eq 3000
      end
    end
  end

  describe '#withdraw' do
    context 'when the balance is less than withdrawal amount' do
      it 'raises an error' do
        expect { bank.withdraw(500) }.to raise_error "Insufficient funds available"
      end
    end
  end
end
