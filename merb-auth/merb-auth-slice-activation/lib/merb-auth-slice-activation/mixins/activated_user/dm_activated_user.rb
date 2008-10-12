class Authentication
  module Mixins
    module ActivatedUser
      module DMClassMethods
        def self.extended(base)
          base.class_eval do
            property :activated_at,    DateTime
            property :activation_code, String

            before :create, :make_activation_code
            after  :create, :send_signup_notification
          end # base.class_eval
        end # self.extended
      end # DMClassMethods
    end # ActivatedUser
  end # Mixins
end # Authentication
