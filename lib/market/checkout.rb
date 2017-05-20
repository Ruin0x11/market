module Market
  class Checkout
    attr_reader :total

    def initialize
      @transactions = []
      @transaction_counts = Hash.new(0)
      @total = 0.0
    end

    def scan(transaction_code)
      unless Market::Transaction::transaction_valid?(transaction_code)
        raise Market::UnknownTransactionError
      end

      @transactions << transaction_code

      @transaction_counts[transaction_code] = @transaction_counts[transaction_code] || 0
      @transaction_counts[transaction_code] += 1

      @total += Market::Transaction::transaction_list[transaction_code][:price]

      apply_discounts!
    end

    def transaction_count(transaction_code)
      @transaction_counts[transaction_code]
    end

    # this could use an external gem to print tables instead.
    def to_s
      str = ""
      str << "Item\t\t\t\tPrice\n"
      str << "----\t\t\t\t-----\n"
      @transactions.each do |t|
        price = Market::Transaction::transaction_list[t][:price]
        type = Market::Transaction::transaction_list[t][:type]
        if type == :discount
          str << "\t\t#{t}\t\t#{price}\n"
        else
          str << "#{t}\t\t\t\t#{price}\n"
        end
      end
      str << "-------------------------------------\n"
      str << "\t\t\t\t#{@total}\n"
    end

    private

    def apply_discounts!
      [Market::CoffeeBogoDiscount,
        Market::ThreeAppleBagDiscount,
        Market::ChaiMilkDiscount].each do |discount|
        while discount.can_apply?(self)
          self.scan(discount.code)
        end
      end
    end
  end
end
