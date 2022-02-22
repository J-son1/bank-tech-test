require 'statement'

class Bank
  def initialize(statement: Statement.new)
    @statement = statement
  end

  def deposit(amount)
    @statement.add_deposit(amount)
  end

  def withdraw(amount)
    @statement.add_withdrawal(amount)
  end

  def view_statement
    @statement.print_statement
  end
end
