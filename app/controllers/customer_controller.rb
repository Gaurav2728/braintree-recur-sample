class CustomerController < ApplicationController

  def new
    @tr_data = Braintree::TransparentRedirect.
                create_customer_data(:redirect_url => confirm_customer_url)
  end

  def edit
    @user = User.find params[:id]
    @user.with_braintree_data!
    @credit_card = @user.default_credit_card
    @tr_data = Braintree::TransparentRedirect.
                update_customer_data(:redirect_url => confirm_customer_url,
                                     :customer_id => @user.braintree_customer_id)
  end

  def confirm
    @result = Braintree::TransparentRedirect.confirm(request.query_string)
    begin 
     @user = User.find_or_initialize_by_braintree_customer_id @result.customer.id 
    rescue
     @user = User.new  
    end  
    if @result.success?
      @user.braintree_customer_id = @result.customer.id
      @user.save!
      redirect_to recur_plans_path(:id => @user.id)
    elsif @user.has_payment_info?
      @user.with_braintree_data!
      render :action => "edit"
    else
      render :action => "new"
    end
  end
end
