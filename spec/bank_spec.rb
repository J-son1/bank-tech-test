require 'bank'

describe Bank do
  subject (:bank) { described_class.new }

  let(:header) { "date || credit || debit || balance\n" }
  let(:date) { Time.now.strftime("%d/%m/%Y") }

  it 'has an initial balance of 0' do
    expect { bank.view_statement }.to output(header).to_stdout
  end

  describe '#deposit' do
    context 'before the first deposit' do
      it 'sets the balance equal to the deposit' do
        bank.deposit(1000)

        expect { bank.view_statement }.to output(header + date + " || 1000 ||  || 1000\n").to_stdout
      end
    end

    context 'after an initial deposit has been made' do
      it 'adds to the balance' do
        transaction_1 = "#{date} || 1000 ||  || 1000\n"
        transaction_2 = "#{date} || 2000 ||  || 3000\n"
        bank.deposit(1000)
        bank.deposit(2000)
        
        expect { bank.view_statement }.to output(header + transaction_1 + transaction_2).to_stdout
      end
    end
  end

  describe '#withdraw' do
    context 'when the withdrawal amount is greater than the balance' do
      it 'raises an error' do
        expect { bank.withdraw(500) }.to raise_error "Insufficient funds available"
      end
    end

    context 'when the withdrawal amount is less than or equal to the balance' do
      it 'deducts the amount from the balance' do
        transaction_1 = "#{date} || 1000 ||  || 1000\n"
        transaction_2 = "#{date} ||  || 500 || 500\n"       
        bank.deposit(1000)
        bank.withdraw(500)

        expect { bank.view_statement }.to output(header + transaction_1 + transaction_2).to_stdout
      end
    end
  end

  describe '#view_statement' do
    context 'when no transactions have been made' do
      it 'prints the statement header' do
        expect { bank.view_statement }.to output(header).to_stdout
      end
    end

    context 'when one or more transactions have been made' do
      it 'prints the deposit amount with the date it was made' do
        bank.deposit(1000)

        expect { bank.view_statement }.to output(header + "#{date} || 1000 ||  || 1000\n").to_stdout
      end

      it 'prints the withdrawal amount with the date it was made' do
        transaction_1 = "#{date} || 1000 ||  || 1000\n"
        transaction_2 = "#{date} ||  || 200 || 800\n"
        bank.deposit(1000)
        bank.withdraw(200)
        
        expect { bank.view_statement }.to output(header + transaction_1 + transaction_2).to_stdout
      end
    end
  end
end
