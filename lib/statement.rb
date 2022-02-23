class Statement
  def initialize
    @balance = 0
    @transactions = []
  end

  def add_transaction(deposit: 0, withdraw: 0)
    create_transaction(credit: deposit, debit: withdraw)
  end

  def print
    create_statement
  end

  private

  def create_transaction(date: date_created, credit: 0, debit: 0)
    raise 'Insufficient funds available' if @balance < debit

    credit.zero? ? credit = '' : @balance += credit
    debit.zero? ? debit = '' : @balance -= debit

    transaction = {
      date: date,
      credit: credit,
      debit: debit,
      balance: @balance
    }

    @transactions << transaction
  end

  def create_statement
    puts 'date || credit || debit || balance'

    @transactions.reverse.each do |t|
      puts "#{t[:date]} || #{t[:credit]} || #{t[:debit]} || #{t[:balance]}"
    end
  end

  def date_created
    Time.new.strftime('%d/%m/%Y')
  end
end
