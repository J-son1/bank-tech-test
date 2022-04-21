# frozen_string_literal: true

require_relative 'statement'

class Bank
  def initialize(statement: Statement.new)
    @statement = statement
    @transactions = []
  end

  def deposit(amount)
    @transactions << @statement.add_transaction(deposit: amount)
  end

  def withdraw(amount)
    @transactions << @statement.add_transaction(withdraw: amount)
  end

  def view_statement
    @statement.print(@transactions)
  end
end
