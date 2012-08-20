# Trying to answer the question: "Why don't we just print more money and give it to the poor?"
# Toby Kurien

SIMULATION_RUNS = 100

# initial monetary conditions
CIRCULATION = 1000000
REPO_RATE = 0
INTEREST_RATE = 0
PRODUCERS = 10
CONSUMERS = 10
PRODUCER_BANK_BALANCE = 1000
CONSUMER_BANK_BALANCE = 50

class Bank
  attr_accessor :reserve_bank, :bank_account, :accounts
  
  class Account
    attr_accessor :balance, :interest_rate, :bank

    def initialize(bank, entity, amount, interest_rate)
        @interest_rate = interest_rate
        @bank = bank
        @balance = amount
    end
    
    def add_interest()
      @balance = @balance * (1 + (@interest_rate/12))
    end
    
    def transfer(to, value)
      raise "Insufficient funds" if @balance < value
      @balance -= value
      to.bank_account.balance += value
    end
    
    def loan(to, value)
      # loan money from reserve bank if the bank doesn't have enough
      bank.reserve_bank.transfer(bank, value - @balance) if @balance < value
      @balance -= value
      to.bank_account.balance += value
    end
  end
  
  def initialize(reserve_bank, amount, interest_rate)
    @reserve_bank = reserve_bank
    @accounts = []
    open_account(self, Bank::Account, amount, interest_rate)
  end
  
  def open_account(entity, account_type, amount, interest_rate)
    entity.bank_account = account_type.new(self, entity, amount, interest_rate)
    reserve_bank.bank_account.loan(self, amount - bank_account.balance) if bank_account.balance < amount
    bank_account.balance -= amount
    accounts << entity.bank_account
  end
end

class ReserveBank < Bank
  def initialize(amount)
    @bank_account = Bank::Account.new(self, self, amount, 0)
  end
  
  def printMoreMoney(amount)
  end
  
  def destroyMoney(amount)
  end
end

class Service
  attr_accessor :price, :cost
end

class Goods
  attr_accessor :price, :cost, :value
end

class Consumer
  attr_accessor :bank_account, :goods
  
  def buyItem(producer)
    item = producer.goods.pop
    goods << item
    bank_account.transfer(producer.bank_account, item.price)
  end

  def buyService(producer)
    goods << item
  end
end

class Producer
  attr_accessor :bank_account, :goods
  
  def initialize
    @goods = []
  end
  
  def make_goods(cost, price, amount)
    amount.times do
        bank_account.transfer(bank_account.bank, cost)
        g1 = Goods.new
        g1.cost = cost
        g1.price = price
        g1.value = price              
        goods << g1
    end
  end
  
  def to_s
    "Producer bank balance=#{bank_account.balance}, goods=#{goods.size}"
  end
end

puts "Running simulation..."

# create the monetary system
@reserve_bank = ReserveBank.new(CIRCULATION)
@bank = Bank.new(@reserve_bank, 0, REPO_RATE)

# create the producers
@producers = []
PRODUCERS.times do
  p = Producer.new
  @bank.open_account(p, Bank::Account, PRODUCER_BANK_BALANCE, INTEREST_RATE)
  p.make_goods(10, 13, 10)
  @producers << p
end

total = @reserve_bank.bank_account.balance
puts "Reserve bank: #{@reserve_bank.bank_account.balance}"
total += @bank.bank_account.balance
puts "Bank: #{@bank.bank_account.balance}"
@producers.each do |p|
    puts p.to_s
    total += p.bank_account.balance
end

puts "Total money: #{total}"
