# frozen_string_literal: true

require_relative 'statement'

class Bank
  def initialize(statement: Statement.new)
    @statement = statement
    @transaction_history = []
  end

  def deposit(amount)
    @transaction_history << @statement.add_transaction(deposit: amount)
  end

  def withdraw(amount)
    @transaction_history << @statement.add_transaction(withdraw: amount)
  end

  def view_statement
    @statement.print(@transaction_history)
  end
end
