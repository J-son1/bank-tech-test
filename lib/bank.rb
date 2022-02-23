# frozen_string_literal: true

require_relative 'statement'

# Allows a user to make desosit or withdrawal transactions
# as well as print a statement to stdout to see their transaction history.
class Bank
  def initialize(statement: Statement.new)
    @statement = statement
  end

  def deposit(amount)
    @statement.add_transaction(deposit: amount)
  end

  def withdraw(amount)
    @statement.add_transaction(withdraw: amount)
  end

  def view_statement
    @statement.print
  end
end
