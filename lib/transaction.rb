class Transaction
  attr_reader :all

  def initialize
    @balance = 0
    @all = []
  end

  def add(deposit: 0, withdraw: 0)    
    update_balance(deposit: deposit, withdraw: withdraw)

    @all << create_transaction(credit: deposit, debit: withdraw)
  end

  private

  def create_transaction(date: date_created, credit: 0, debit: 0, balance: @balance)
    credit = "" if credit == 0
    debit = "" if debit == 0

    transaction = {
      date: date,
      credit: credit,
      debit: debit,
      balance: balance
    }
  end

  def update_balance(deposit: 0, withdraw: 0)
    raise "Insufficient funds available" if @balance < withdraw
    @balance += deposit
    @balance -= withdraw
    
    @balance
  end

  def date_created
    Time.new.strftime("%d/%m/%Y")
  end
end
