class ApplicationController < ActionController::Base
    before_action :categories
    before_action :initialize_session
    helper_method :cart

    def categories
        category_names = ['Clothing', 'Furniture', 'Home & Kitchen', 'Computers', 'Beauty and Personal Care', 'Sports & Fitness']
        @categories = Category.where(name: category_names)
    end

    def login
        user = User.find_by(email: params[:email])
        # if user && user.authenticate(params[:password])
        #     redirect_to root_path, notice: 'Logged in successfully!'
        # else
        #     flash.now[:alert] = 'Invalid email or password'
        #     redirect_to root_path, notice: 'Login failed'
        # end
        session[:user] = user.email
        redirect_to root_path, notice: 'Logged in successfully!'
    end

    def logout
        session[:user] = nil
        redirect_to root_path, notice: 'Logged out successfully!'
    end

    def register
        user = User.new(user_params)
        if user.save
            redirect_to root_path, notice: 'Registered successfully!'
        else
            flash.now[:alert] = 'Error registering user'
        end
    end

    private

    def initialize_session
        session[:shopping_cart] ||= {}
    end

    def cart
        if session[:shopping_cart].is_a?(Hash)
            product_ids = session[:shopping_cart].keys
            Product.where(id: product_ids)
        else
            []
        end
    end

    def user_params
        params.require(:user).permit(:email, :password, :first_name, :last_name)
    end
end