class Authentication
  module Mixins
    module ActivatedUser
      module SQClassMethods
        def self.extended(base)
          base.class_eval do
            before_save :make_activation_code
            after_save  :send_signup_notification
          end # base.class_eval
        end # self.extended
      end # SQClassMethods
      module SQInstanceMethods
      end # SQInstanceMethods
    end # ActivatedUser
  end # Mixins
end # Authentication
