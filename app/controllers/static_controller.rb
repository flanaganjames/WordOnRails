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

def manualmovepvc  #posted from "static/compusergameboard"
      i=0
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
      @tilename = {}
      i = 0
      while i < 7
          @tilename[i] = "tile" + i.to_s
          i += 1
      end
      @word = params["word"]
      @xcoordinate = params["xcoordinate"]
      @ycoordinate = params["ycoordinate"]
      @direction = params["direction"]
      aSW = ScrabbleWord.new(@word, @xcoordinate.to_i, @ycoordinate.to_i, @direction, 0, 0)
      $aWordfriend.updatevalues($aGame.tilesplayer2)
      status = $aWordfriend.manualwordtest(aSW) #this changes scoregrid if  a '*' to be used. Be sure to roll back if move not accepted
      if status
          $aGame.placewordfromtiles2(aSW)
          $aGame.saveboard
          render template: "static/showupdatedpvc"
          else
          dummy = 0
          render template: "static/showinvalidmove"  #for some reason this cannot be the first statement after else
      end
      
  end

  def showinvalidmove
      
  end

  def revertpvc
      i=0
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
      
      @tilename = {}
      i = 0
      while i < 7
          @tilename[i] = "tile" + i.to_s
          i += 1
      end
      
      $aGame.revertPvC
      render template: "static/compusergameboard"
  end
  
  def nextmoveplayer1
      
      $aGame.nextmovePlayer1
      $task = Thread.new {
          $aWordfriend.wordfind}
      render template: "static/showberightbackcomp"
  end
  
  def shownextmoveplayer1
      i=0
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
      $aGame.finishnextmovePlayer1
      render template: "static/compusergameboard"
  end
  
  def gettingresultspvc  #posted from "static/compusergameboard"
      i=0
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
      
      @tilename = {}
      i = 0
      while i < 7
          @tilename[i] = "tile" + i.to_s
          i += 1
      end
      
      $aGame.currentplayertileset = $aGame.tilesplayer2
      $aWordfriend.updatevalues($aGame.tilesplayer2)
      $task = Thread.new {
          $aWordfriend.wordfind}
      render template: "static/showberightbackpvc"
  end
  
  def showresultspvc  #called from showberightback

  end
  
  def updatedpvcfind  #called from showresultspvc
      i=0
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
      
      @tilename = {}
      i = 0
      while i < 7
          @tilename[i] = "tile" + i.to_s
          i += 1
      end
      
      @choice = params["choice"]
      @word = params["word"+@choice.to_s]
      @xcoordinate = params["xcoordinate"+@choice.to_s]
      @ycoordinate = params["ycoordinate"+@choice.to_s]
      @direction = params["direction"+@choice.to_s]
      @score = params["score"+@choice.to_s]
      @supplement = params["supplement"+@choice.to_s]
      
      aSW = ScrabbleWord.new(@word, @xcoordinate.to_i, @ycoordinate.to_i, @direction, @score.to_i, @supplement.to_i)
      
      $aGame.placewordfromtiles2(aSW)
  end
  
  def revertpvcfind
      $aGame.revertPvC
      render template: "showresultspvc"
      
  end

  def resumegame
      
  end

  def cheatgame
    
  end

  
  def stub1
  end
  
  def stub2
  end
end
