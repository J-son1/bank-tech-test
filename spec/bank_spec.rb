# frozen_string_literal: true

require 'bank'

describe Bank do
  subject(:bank) { described_class.new(statement: statement) }

  let(:statement) { double('statement') }

  before(:each) do
    allow(statement).to receive(:add_transaction)
    allow(statement).to receive(:view_statement)
  end

  describe '#deposit' do
    it 'should create a deposit transaction' do
      expect(statement).to receive(:add_transaction)

      bank.deposit(1000)
    end
  end

  describe '#withdraw' do
    it 'should create a withdrawal transaction' do
      bank.deposit(1000)
      expect(statement).to receive(:add_transaction)

      bank.withdraw(500)
    end
  end

  describe '#view_statement' do
    it 'can display a list of transactions' do
      bank.deposit(1000)
      bank.withdraw(500)
      bank.deposit(2000)
      expect(statement).to receive(:print)

      bank.view_statement
    end
  end
end
