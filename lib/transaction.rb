# frozen_string_literal: true

# Handles the logic for creating transactions
# and updating the account balance.
class Transaction
  def initialize
    @balance = 0
    @transactions = []
  end

  def create(credit: 0, debit: 0)
    create_transaction(credit: credit, debit: debit)
  end

  def all
    @transactions
  end

  private

  def create_transaction(credit: 0, debit: 0)
    raise 'Insufficient funds available' if @balance < debit

    @balance += credit
    @balance -= debit

    transaction = { date: date_created, credit: credit, debit: debit, balance: @balance }

    @transactions << transaction
    transaction
  end

  def date_created
    Time.new.strftime('%d/%m/%Y')
  end
end
