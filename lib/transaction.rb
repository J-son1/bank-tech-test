# frozen_string_literal: true

class Transaction
  def initialize
    @balance = 0
  end

  def create(credit: 0, debit: 0)
    create_transaction(credit: credit, debit: debit)
  end

  private

  def create_transaction(credit: 0, debit: 0)
    raise 'Insufficient funds available' if @balance < debit

    @balance += credit
    @balance -= debit

    transaction = { 
      date: date_created,
      credit: credit,
      debit: debit,
      balance: @balance
    }
  end

  def date_created
    Time.new.strftime('%d/%m/%Y')
  end
end
