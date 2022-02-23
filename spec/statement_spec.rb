# frozen_string_literal: true

require 'statement'

describe Statement do
  subject(:statement) { described_class.new }

  let(:header) { "date || credit || debit || balance\n" }
  let(:date) { Time.now.strftime('%d/%m/%Y') }

  it 'has an initial balance of 0' do
    expect { statement.print }.to output(header).to_stdout
  end

  describe '#add_transaction' do
    context 'when the transaction is a deposit' do
      context 'before the first deposit' do
        it 'sets the balance equal to the deposit' do
          statement.add_transaction(deposit: 1000.55)

          expect { statement.print }.to output("#{header}#{date} || 1000.55 ||  || 1000.55\n").to_stdout
        end
      end

      context 'after an initial deposit has been made' do
        it 'adds to the balance' do
          transaction1 = "#{date} || 1000.55 ||  || 1000.55\n"
          transaction2 = "#{date} || 2000.00 ||  || 3000.55\n"
          statement.add_transaction(deposit: 1000.55)
          statement.add_transaction(deposit: 2000)

          expect { statement.print }.to output(header + transaction2 + transaction1).to_stdout
        end
      end
    end

    context 'when the transaction is a withdrawal' do
      context 'when amount is greater than the balance' do
        it 'raises an error' do
          expect { statement.add_transaction(withdraw: 500) }.to raise_error 'Insufficient funds available'
        end
      end

      context 'when the amount is less than or equal to the balance' do
        it 'deducts the amount from the balance' do
          transaction1 = "#{date} || 1000.55 ||  || 1000.55\n"
          transaction2 = "#{date} ||  || 500.00 || 500.55\n"
          statement.add_transaction(deposit: 1000.55)
          statement.add_transaction(withdraw: 500)

          expect { statement.print }.to output(header + transaction2 + transaction1).to_stdout
        end
      end
    end
  end

  describe '#print' do
    context 'when no transactions have been made' do
      it 'prints the statement header' do
        expect { statement.print }.to output(header).to_stdout
      end
    end

    context 'when one or more transactions have been made' do
      it 'prints the deposit amount to 2 decimal places with the date it was made' do
        statement.add_transaction(deposit: 1000.55)

        expect { statement.print }.to output(header + "#{date} || 1000.55 ||  || 1000.55\n").to_stdout
      end

      it 'prints the withdrawal amount with the date it was made' do
        transaction1 = "#{date} || 1000.55 ||  || 1000.55\n"
        transaction2 = "#{date} ||  || 200.00 || 800.55\n"
        statement.add_transaction(deposit: 1000.55)
        statement.add_transaction(withdraw: 200)

        expect { statement.print }.to output(header + transaction2 + transaction1).to_stdout
      end

      it 'prints the transactions in reverse chronological order' do
        transaction1 = "#{date} || 1000.55 ||  || 1000.55\n"
        transaction2 = "#{date} ||  || 200.55 || 800.00\n"
        transaction3 = "#{date} || 3000.55 ||  || 3800.55\n"
        statement.add_transaction(deposit: 1000.55)
        statement.add_transaction(withdraw: 200.55)
        statement.add_transaction(deposit: 3000.55)

        expect { statement.print }.to output(header + transaction3 + transaction2 + transaction1).to_stdout
      end
    end
  end
end
