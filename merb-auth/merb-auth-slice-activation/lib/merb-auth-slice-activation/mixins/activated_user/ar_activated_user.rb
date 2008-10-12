class Authentication
  module Mixins
    module ActivatedUser
      module ARClassMethods
        def self.extended(base)
          base.class_eval do
            before :create, :make_activation_code
            after  :create, :send_signup_notification
          end # base.class_eval
        end # self.extended
      end # ARClassMethods
    end # ActivatedUser
  end # Mixins
end # Authentication
