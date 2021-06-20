module SessionsHelper

	#log in with the given user
	def Log_in user
		session[:user_id] = user.id

	end

    #return a current user logged in
	def current_user
	    if session[:user_id]
	      @current_user ||= User.find_by(id: session[:user_id])
	    end
    end

    #A user is logged in IF current_user is not nil
    def logged_in?
    	!current_user.nil?
    end

    def log_out
    	session.delete(user_id)
    	@current_user = nil
    end

end
