class StaticController < ApplicationController
  def home
  end
  
  def usergame
      if (params["ausername"] == '' || params["pin1"] == '' || params["pin2"] == '' || params["pin3"] == '' || params["pin4"] == '')
          then
           puts "invalid user pin"
          else
           puts "valid user pin"
          
      end
  end

end
