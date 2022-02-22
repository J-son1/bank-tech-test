class Bank
  attr_reader :balance

  def initialize
    @balance = 0
    @transactions = []
  end

  def deposit(amount)
    @balance += amount

    @transactions << create_transaction(date: "", credit: amount, debit: "", balance: @balance)
  end

  def withdraw(amount)
    raise "Insufficient funds available" if @balance < amount

    @balance -= amount

    @transactions << create_transaction(date: "", credit: "", debit: amount, balance: @balance)
  end

  def view_statement
    puts "date || credit || debit || balance"
    
    @transactions.each do |t|
      puts "#{t[:date]} || #{t[:credit]} || #{t[:debit]} || #{t[:balance]}"
    end
  end

  private

  def create_transaction(date:, credit:, debit:, balance:)
    transaction = {
      date: date,
      credit: credit,
      debit: debit,
      balance: balance
    }
  end
end
