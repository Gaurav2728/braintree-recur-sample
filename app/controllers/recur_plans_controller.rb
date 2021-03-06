class RecurPlansController < ApplicationController

  def index
    #@plans = Braintree::Plan.all 
    #raise @plans.inspect
     customer_id = User.find(params[:id]).braintree_customer_id
     customer = Braintree::Customer.find(customer_id)
     payment_method_token = customer.credit_cards[0].token

     result = Braintree::Subscription.create(
               :payment_method_token => payment_method_token,
               :plan_id => "recuryr"
              )

     flash[:notice] = "Subscription status: #{result.subscription.status}"
     redirect_to root_path
  end  

end
