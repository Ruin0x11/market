require_relative './transaction.rb'
include Market

module Market
  class Discount
    class << self
      def can_apply?(checkout)
        false
      end

      def code
        ""
      end
    end
  end

  class CoffeeBogoDiscount < Discount
    class << self
      def can_apply?(checkout)
        checkout.transaction_count(COFFEE) - checkout.transaction_count(self.code) > 1
      end

      def code
        BOGO_DISCOUNT
      end
    end
  end

  class ThreeAppleBagDiscount < Discount
    class << self
      def can_apply?(checkout)
        amount_good = checkout.transaction_count(APPLES) >= 3
        unaccounted = checkout.transaction_count(APPLES) - checkout.transaction_count(self.code) > 0
        amount_good && unaccounted
      end

      def code
        APPLE_DISCOUNT
      end
    end
  end

  class ChaiMilkDiscount < Discount
    class << self
      def can_apply?(checkout)
        limit_reached = checkout.transaction_count(self.code) > 0
        has_chai = checkout.transaction_count(CHAI) > 0
        has_milk = checkout.transaction_count(MILK) - checkout.transaction_count(CHAI) == 0
        unaccounted = checkout.transaction_count(MILK) - checkout.transaction_count(self.code) > 0
        !limit_reached && has_chai && has_milk && unaccounted
      end

      def code
        CHAI_MILK_DISCOUNT
      end
    end
  end
end
