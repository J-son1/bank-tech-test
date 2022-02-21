describe 'User Stories' do
  subject(:bank) { Bank.new }
  
  # As a earner
  # So that I can store my money somewhere
  # I want to make deposits in a bank
  it 'takes a deposit' do
    expect { bank.deposit(1000) }.to_not raise_error
  end
end
