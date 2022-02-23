# frozen_string_literal: true

describe 'User Stories' do
  subject(:bank) { Bank.new }

  # As a earner
  # So that I can store my money somewhere
  # I want to make deposits in a bank
  it 'takes a deposit' do
    expect { bank.deposit(1000) }.to_not raise_error
  end

  # As a earner
  # So that use my money
  # I want to make withdrawals
  it 'accepts withdrawals' do
    bank.deposit(1000)

    expect { bank.withdraw(500) }.to_not raise_error
  end
end
