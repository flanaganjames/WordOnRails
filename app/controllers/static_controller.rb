require 'rubygems'
require './resource_Wordfriend'
require './resource_Game'
require 'daemons'


class StaticController < ApplicationController
  def home
      $aGame = Game.new
      $aGame.initialvalues
  end
  
  def usercheck
      $aGame.gameuser = params["ausername"] + params["pin1"] + params["pin2"] + params["pin3"] + params["pin4"]
      $aWordfriend.gameuser = $aGame.gameuser
      $aWordfriend.createuserdirectory #creates the user directory if it does not exist already
      $aGame.getusergame
      if $aGame.newgame == "no"
          render template: "static/userchoose" #ask if resume or new
      else
          $aGame.initializegame
          render template: "stub2"  #ask mode
      end

  end
  
  def userchoose
  end
  
  
  def askmode
      $aGame.initializegame
      render stub2 #ask mode
  end
  
  def stub1
  end
  
  def stub2
  end
end
