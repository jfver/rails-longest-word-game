require 'net/http'
require 'json'

class GamesController < ApplicationController

  def new
    @lettres = ('a'..'z').to_a
    @grid = @lettres.sample(10)
    session[:grid] = @grid
  end

  def check_word
    # Récupérer le mot depuis les paramètres de la requête
    word = params[:word]

    # Effectuer une requête à l'API du dictionnaire Wagon
    api_url = "https://wagon-dictionary.herokuapp.com/#{word}"
    uri = URI(api_url)
    response = Net::HTTP.get(uri)
    result = JSON.parse(response)

    # Vérifier si le mot existe en fonction de la réponse de l'API
    if result['found'] == true
      @resultat = "Le mot #{word} existe dans le dictionnaire Wagon"
    else
      @resultat = "Le mot #{word} n'existe pas dans le dictionnaire Wagon. Réessayer"
    end
  end

  def score
    @word = params[:word]
    @grid = session[:grid]
    @grid_origin = @grid.clone
    @word.each_char do |character|
      unless @grid.include?(character)
        @error = 1
      end
      if @grid.include?(character)
        @grid.delete(character)
      end
      #verifying if letters entered by users are in grid
    end
    check_word


    if @error == 1
      # flash[:error] = "Please enter a valid word"
      # redirect_to new_path
      @resultat = "Désolé, mais le mot #{@word} n'est pas composé des lettres #{@grid_origin.join(',')}"
    end
  end
end


