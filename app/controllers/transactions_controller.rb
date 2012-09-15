class TransactionsController < ApplicationController

  def new
    @product = Product.new
    @user = User.last
    if @user.has_payment_info?
      @user.with_braintree_data!
      @credit_card = @user.default_credit_card
      @price = 500.00
      @tr_data = Braintree::TransparentRedirect.transaction_data(:redirect_url => confirm_transaction_url(:user_id => @user.id),
                                                                 :transaction => {
                                                                   :amount => @price,
                                                                   :type => "sale",
                                                                   :customer_id => @user.braintree_customer_id
                                                                  })
    else
      redirect_to new_customer_path
    end
  end

  def confirm
    @user = User.find params[:user_id]
    @result = Braintree::TransparentRedirect.confirm(request.query_string)

    if @result.success?
      render :confirm
    else
      @product = Product.new
      @user.with_braintree_data!
      @credit_card = @user.default_credit_card
      render :new
    end
  end

end
