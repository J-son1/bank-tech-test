# frozen_string_literal: true

require 'transaction'

describe Transaction do
  subject(:transaction) { described_class.new }

  let(:date) { Time.now.strftime('%d/%m/%Y') }

  let(:transactions) do
    [{ date: date, credit: 1000.55, debit: 0, balance: 1000.55 },
     { date: date, credit: 0, debit: 200.55, balance: 800 },
     { date: date, credit: 3000.55, debit: 0, balance: 3800.55 }]
  end

  describe '#create' do
    it 'creates a deposit transaction' do
      transaction.create(credit: 1000.55)

      expect(transaction.all.first).to eq transactions[0]
    end

    it 'creates a withdrawal transaction' do
      transaction.create(credit: 1000.55)
      transaction.create(debit: 200.55)

      expect(transaction.all.last).to eq transactions[1]
    end
  end

  describe '#all' do
    it 'returns an array of transactions' do
      transaction.create(credit: 1000.55)
      transaction.create(debit: 200.55)
      transaction.create(credit: 3000.55)

      expect(transaction.all).to eq transactions
      expect(transaction.all.length).to eq 3
    end
  end
end
