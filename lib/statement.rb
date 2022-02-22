class Statement
  def initialize
    @balance = 0
    @transactions = []
  end

  def add_deposit(amount)
    @balance += amount

    @transactions << create_transaction(credit: amount)
  end

  def add_withdrawal(amount)
    raise "Insufficient funds available" if @balance < amount
    @balance -= amount

    @transactions << create_transaction(debit: amount)
  end

  def print_statement
    puts "date || credit || debit || balance"
    
    @transactions.each do |t|
      puts "#{t[:date]} || #{t[:credit]} || #{t[:debit]} || #{t[:balance]}"
    end
  end

  private

  def create_transaction(date: date_created, credit: "", debit: "", balance: @balance)
    transaction = {
      date: date,
      credit: credit,
      debit: debit,
      balance: balance
    }
  end

  def date_created
    Time.new.strftime("%d/%m/%Y")
  end
end
