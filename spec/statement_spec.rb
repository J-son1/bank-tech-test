# frozen_string_literal: true

require 'statement'

describe Statement do
  subject(:statement) { described_class.new(transaction: transaction) }

  before do
    Timecop.freeze(Time.now)
  end

  after do
    Timecop.return
  end

  let(:date) { Time.now.strftime('%d/%m/%Y') }
  let(:header) { "date || credit || debit || balance\n" }
  let(:transaction) { double('transaction') }

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

    expect { statement.print }.to output(header).to_stdout
  end

  describe '#add_transaction' do
    context 'when the transaction is a deposit' do
      context 'before the first deposit' do
        it 'sets the balance equal to the deposit' do
          allow(transaction).to receive(:create)
          allow(transaction).to receive(:all).and_return([transactions_data[0]])

          statement.add_transaction(deposit: 1000.55)

          expect(transaction).to have_received(:create).with({ credit: 1000.55, debit: 0 })
          expect { statement.print }.to output("#{header}#{date} || 1000.55 ||  || 1000.55\n").to_stdout
        end
      end

      context 'after an initial deposit has been made' do
        it 'adds to the balance' do
          t2 = { date: date, credit: 3000.55, debit: 0, balance: 4001.10 }
          transaction2 = "#{date} || 3000.55 ||  || 4001.10\n"

          allow(transaction).to receive(:all).and_return([transactions_data[0], t2])

          expect(transaction).to receive(:create).with({ credit: 1000.55, debit: 0 })
          expect(transaction).to receive(:create).with({ credit: 3000.55, debit: 0 })

          statement.add_transaction(deposit: 1000.55)
          statement.add_transaction(deposit: 3000.55)

          expect { statement.print }.to output(header + transaction2 + transactions_output[0]).to_stdout
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
          allow(transaction).to receive(:all).and_return([transactions_data[0], transactions_data[1]])

          expect(transaction).to receive(:create).with({ credit: 1000.55, debit: 0 })
          expect(transaction).to receive(:create).with({ credit: 0, debit: 200.55 })

          statement.add_transaction(deposit: 1000.55)
          statement.add_transaction(withdraw: 200.55)

          expect { statement.print }.to output(header + transactions_output[1] + transactions_output[0]).to_stdout
        end
      end
    end
  end

  describe '#print' do
    context 'when no transactions have been made' do
      it 'prints the statement header' do
        allow(transaction).to receive(:all) { [] }

        expect { statement.print }.to output(header).to_stdout
      end
    end

    context 'when one or more transactions have been made' do
      it 'prints the deposit amount to 2 decimal places with the date it was made' do
        allow(transaction).to receive(:all).and_return([transactions_data[0]])

        expect(transaction).to receive(:create).with({ credit: 1000.55, debit: 0 })

        statement.add_transaction(deposit: 1000.55)

        expect { statement.print }.to output(header + transactions_output[0]).to_stdout
      end

      it 'prints the withdrawal amount with the date it was made' do
        allow(transaction).to receive(:all).and_return([transactions_data[0], transactions_data[1]])

        expect(transaction).to receive(:create).with({ credit: 1000.55, debit: 0 })
        expect(transaction).to receive(:create).with({ credit: 0, debit: 200.55 })

        statement.add_transaction(deposit: 1000.55)
        statement.add_transaction(withdraw: 200.55)

        expect { statement.print }.to output(header + transactions_output[1] + transactions_output[0]).to_stdout
      end

      it 'prints the transactions in reverse chronological order' do
        allow(transaction).to receive(:all).and_return(transactions_data)

        expect(transaction).to receive(:create).with({ credit: 1000.55, debit: 0 })
        expect(transaction).to receive(:create).with({ credit: 0, debit: 200.55 })
        expect(transaction).to receive(:create).with({ credit: 3000.55, debit: 0 })

        statement.add_transaction(deposit: 1000.55)
        statement.add_transaction(withdraw: 200.55)
        statement.add_transaction(deposit: 3000.55)

        expect { statement.print }.to output(header + transactions_output.reverse.join).to_stdout
      end
    end
  end
end
