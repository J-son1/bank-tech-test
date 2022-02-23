# frozen_string_literal: true

require_relative 'transaction'

# Prints statements.
class Statement
  def initialize(transaction: Transaction.new)
    @transaction = transaction
  end

  def add_transaction(deposit: 0, withdraw: 0)
    @transaction.create(credit: deposit, debit: withdraw)
  end

  def print
    print_statement(@transaction.all)
  end

  private

  def print_statement(transactions)
    puts 'date || credit || debit || balance'

    transactions.reverse.map do |t|
      credit = t[:credit].zero? ? '' : '%.2f' % [t[:credit]]
      debit = t[:debit].zero? ? '' : '%.2f' % [t[:debit]]
      balance = '%.2f' % [t[:balance]]

      puts "#{t[:date]} || #{credit} || #{debit} || #{balance}"
    end
  end
end
