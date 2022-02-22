require_relative 'transaction'

class Statement
  def initialize(transaction: Transaction.new)
    @transaction = transaction
  end

  def add_transaction(deposit: 0, withdrawal: 0)
    @transaction.add(deposit: deposit, withdrawal: withdrawal)
  end

  def print
    puts "date || credit || debit || balance"
    
    @transaction.all.each do |t|
      puts "#{t[:date]} || #{t[:credit]} || #{t[:debit]} || #{t[:balance]}"
    end
  end
end
