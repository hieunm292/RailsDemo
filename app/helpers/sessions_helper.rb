module SessionsHelper

	#log in with the given user
	def Log_in user
		session[:user_id] = user.id

	end

	# Remembers a user in a persistent session.
	def remember user
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		# setting a cookie that expires 20 years
		cookies.permanent[:remember_token] = user.remember_token
	end


    #return a current user logged injectinit { |mem, var|  }
	def current_user

	    if (user_id = session[:user_id])
			@current_user ||= User.find_by(id: user_id)

		#cookies signed encrypts the cookie before placing it on the browser
		elsif (user_id = cookies.signed[:user_id])
			user = User.find_by(id: user_id)

		    if user && user.authenticated?(cookies[:remember_token])
			    log_in user
			    @current_user = user

			end
		end

    end

    #A user is logged in IF current_user is not nil
    def logged_in?
    	!current_user.nil?
    end


    # Forgets a persistent session.
	def forget user 
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end


    def log_out
    	forget(current_user)
    	session.delete(:user_id)
    	@current_user = nil
    end

end
