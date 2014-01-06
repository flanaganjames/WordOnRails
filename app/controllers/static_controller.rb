require 'rubygems'
require './resource_Wordfriend'
require './resource_Game'
require 'daemons'


class StaticController < ApplicationController
  def home
      $aGame = Game.new
      $aGame.initialvalues
  end
  
  def usercheck #from static/home
      $aGame.gameuser = params["ausername"] + params["pin1"] + params["pin2"] + params["pin3"] + params["pin4"]
      $aWordfriend.gameuser = $aGame.gameuser
      $aWordfriend.createuserdirectory #creates the user directory if it does not exist already
      $aGame.getusergame
      if $aGame.newgame == "no"
          render template: "static/userchoose" #ask if resume > static/resume or new > static/askmode
      else
          $aGame.initializegame
          render template: "static/askmode"
      end

  end
  
  def askmode
      $aGame.initializegame
      render template: "static/askmode"  #ask if PvC > static/pvcgame or Cheat > static/cheatgame
  end
  
  def pvcgame
      $aGame.initializegamePvC
      $aGame.firstmove
      i= 0
      @posname = {}
      while i < 15
          j = 0
          lhash = {}
          while j < 15
              lhash[j] = ":i" + i.to_s + "j" + j.to_s
              j += 1
          end
          @posname[i] = lhash
          i += 1
      end
      render template: "static/compusergameboard"
  end

  def cheatgame

  end
  
  def resumegame
      
  end

  
  def stub1
  end
  
  def stub2
  end
end
