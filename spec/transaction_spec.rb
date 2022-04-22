# frozen_string_literal: true

require 'transaction'

describe Transaction do
  subject(:transaction) { described_class.new }

  before { Timecop.freeze(Time.now) }
  after { Timecop.return }

  let(:date) { Time.now.strftime('%d/%m/%Y') }
  let(:transaction_history) { [] }
  let(:transaction_data) { {} }
  let(:transactions_data) do
    [{ date: date, credit: 1000.55, debit: 0, balance: 1000.55 },
     { date: date, credit: 0, debit: 200.55, balance: 800 },
     { date: date, credit: 3000.55, debit: 0, balance: 3800.55 }]
  end

  describe '#create' do
    it 'creates a deposit transaction' do
      transaction_data = transaction.create(credit: 1000.55)

      expect(transaction_data).to eq transactions_data[0]
    end

    it 'creates a withdrawal transaction' do
      transaction_history << transaction.create(credit: 1000.55)
      transaction_history << transaction.create(debit: 200.55)

      expect(transaction_history.last).to eq transactions_data[1]
    end
  end
end
