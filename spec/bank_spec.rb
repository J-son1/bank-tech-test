# frozen_string_literal: true

require 'bank'

describe Bank do
  subject(:bank) { described_class.new(statement: statement) }
  
  before { Timecop.freeze(Time.now) }
  after { Timecop.return }
  
  let(:date) { Time.now.strftime('%d/%m/%Y') }
  
  let(:transactions) do
    [{ date: date, credit: 1000.55, debit: 0, balance: 1000.55 },
      { date: date, credit: 0, debit: 200.55, balance: 800 },
      { date: date, credit: 3000.55, debit: 0, balance: 3800.55 }]
  end
    
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
      allow(statement).to receive(:add_transaction).with(deposit:1000.55).and_return(transactions[0])
      allow(statement).to receive(:add_transaction).with(withdraw:200.55).and_return(transactions[1])
      allow(statement).to receive(:add_transaction).with(deposit:3800.55).and_return(transactions[2])
      bank.deposit(1000.55)
      bank.withdraw(200.55)
      bank.deposit(3800.55)
      expect(statement).to receive(:print).with(transactions)

      bank.view_statement
    end
  end
end
