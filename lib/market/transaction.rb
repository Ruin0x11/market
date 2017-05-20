module Market
  # this data could be placed in a database instead.
  CHAI               = "CH1"
  APPLES             = "AP1"
  COFFEE             = "CF1"
  MILK               = "MK1"

  BOGO_DISCOUNT      = "BOGO"
  APPLE_DISCOUNT     = "APPL"
  CHAI_MILK_DISCOUNT = "CHMK"

  class Transaction
    class << self
      def transaction_list
        { CHAI               => { name: "Chai", type: :item, price: 3.11 },
          APPLES             => { name: "Apples", type: :item, price: 6.00 },
          COFFEE             => { name: "Coffee", type: :item, price: 11.23 },
          MILK               => { name: "Milk", type: :item, price: 4.75 },

          BOGO_DISCOUNT      => { name: "BOGO Special on Coffee", type: :discount, price: -11.23 },
          APPLE_DISCOUNT     => { name: "3 or more Apples", type: :discount, price: -1.50 },
          CHAI_MILK_DISCOUNT => { name: "Free Milk with Chai", type: :discount, price: -4.75 }, }
      end

      def transaction_valid?(code)
        self::transaction_list.key?(code)
      end
    end

    attr_reader :type, :amount

    def initialize(code, type, amount)
      @type = type
      @amount = amount
    end
  end
end
