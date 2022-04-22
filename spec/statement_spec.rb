# frozen_string_literal: true

require 'statement'

describe Statement do
  subject(:statement) { described_class.new(transaction: transaction) }

  before { Timecop.freeze(Time.now) }
  after { Timecop.return }

  let(:date) { Time.now.strftime('%d/%m/%Y') }
  let(:header) { "date || credit || debit || balance\n" }
  let(:transaction) { double('transaction') }
  let(:transaction_history) { [] }

  let(:transactions_data) do
    [{ date: date, credit: 1000.55, debit: 0, balance: 1000.55 },
     { date: date, credit: 0, debit: 200.55, balance: 800 },
     { date: date, credit: 3000.55, debit: 0, balance: 3800.55 }]
  end

  let(:transactions_output) do
    ["#{date} || 1000.55 ||  || 1000.55\n",
     "#{date} ||  || 200.55 || 800.00\n",
     "#{date} || 3000.55 ||  || 3800.55\n"]
  end

  it 'has an initial balance of 0' do
    allow(statement).to receive(:print) { puts header }

    expect { statement.print(transactions_data) }.to output(header).to_stdout
  end

  describe '#add_transaction' do
    context 'when the transaction is a deposit' do
      context 'before the first deposit' do
        it 'sets the balance equal to the deposit' do
          expected = "#{header}#{date} || 1000.55 ||  || 1000.55\n"
          
          expect(transaction).to receive(:create).with({ credit: 1000.55, debit: 0 }).and_return(transactions_data[0])

          transaction_history << statement.add_transaction(deposit: 1000.55)

          expect { statement.print(transaction_history) }.to output(expected).to_stdout
        end
      end

      context 'after an initial deposit has been made' do
        it 'adds to the balance' do
          transaction2_data = { date: date, credit: 3000.55, debit: 0, balance: 4001.10 }
          transaction2_output = "#{date} || 3000.55 ||  || 4001.10\n"
          expected = header + transaction2_output + transactions_output[0]

          expect(transaction).to receive(:create).with({ credit: 1000.55, debit: 0 }).and_return(transactions_data[0])
          expect(transaction).to receive(:create).with({ credit: 3000.55, debit: 0 }).and_return(transaction2_data)

          transaction_history << statement.add_transaction(deposit: 1000.55)
          transaction_history << statement.add_transaction(deposit: 3000.55)

          expect { statement.print(transaction_history) }.to output(expected).to_stdout
        end
      end
    end

    context 'when the transaction is a withdrawal' do
      context 'when amount is greater than the balance' do
        it 'raises an error' do
          allow(transaction).to receive(:create) { raise 'Insufficient funds available' }

          expect { statement.add_transaction(withdraw: 500) }.to raise_error 'Insufficient funds available'
        end
      end

      context 'when the amount is less than or equal to the balance' do
        it 'deducts the amount from the balance' do
          expected = header + transactions_output[1] + transactions_output[0]

          expect(transaction).to receive(:create).with({ credit: 1000.55, debit: 0 }).and_return(transactions_data[0])
          expect(transaction).to receive(:create).with({ credit: 0, debit: 200.55 }).and_return(transactions_data[1])

          transaction_history << statement.add_transaction(deposit: 1000.55)
          transaction_history << statement.add_transaction(withdraw: 200.55)

          expect { statement.print(transaction_history) }.to output(expected).to_stdout
        end
      end
    end
  end

  describe '#print' do
    context 'when no transactions have been made' do
      it 'prints the statement header' do
        allow(transaction).to receive(:all) { [] }

        expect { statement.print([]) }.to output(header).to_stdout
      end
    end

    context 'when one or more transactions have been made' do
      it 'prints the deposit amount to 2 decimal places with the date it was made' do
        expected = header + transactions_output[0]
        
        expect(transaction).to receive(:create).with({ credit: 1000.55, debit: 0 }).and_return(transactions_data[0])

        transaction_history << statement.add_transaction(deposit: 1000.55)

        expect { statement.print(transaction_history) }.to output(expected).to_stdout
      end

      it 'prints the withdrawal amount with the date it was made' do
        expected = header + transactions_output[1] + transactions_output[0]

        expect(transaction).to receive(:create).with({ credit: 1000.55, debit: 0 }).and_return(transactions_data[0])
        expect(transaction).to receive(:create).with({ credit: 0, debit: 200.55 }).and_return(transactions_data[1])

        transaction_history << statement.add_transaction(deposit: 1000.55)
        transaction_history << statement.add_transaction(withdraw: 200.55)

        expect { statement.print(transaction_history) }.to output(expected).to_stdout
      end

      it 'prints the transactions in reverse chronological order' do
        expected = header + transactions_output.reverse.join
        
        expect(transaction).to receive(:create).with({ credit: 1000.55, debit: 0 }).and_return(transactions_data[0])
        expect(transaction).to receive(:create).with({ credit: 0, debit: 200.55 }).and_return(transactions_data[1])
        expect(transaction).to receive(:create).with({ credit: 3000.55, debit: 0 }).and_return(transactions_data[2])

        transaction_history << statement.add_transaction(deposit: 1000.55)
        transaction_history << statement.add_transaction(withdraw: 200.55)
        transaction_history << statement.add_transaction(deposit: 3000.55)

        expect { statement.print(transaction_history) }.to output(expected).to_stdout
      end
    end
  end
end
