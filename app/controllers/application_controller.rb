class ApplicationController < ActionController::Base
	def helloXXX
		render html: "Hello World"
	end

	def goodBye
		render html: "Goodbye World"
	end
end
