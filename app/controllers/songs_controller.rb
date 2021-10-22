require 'rack-flash'

class SongsController < ApplicationController
  enable :sessions
  use Rack::Flash

  get '/songs' do
    @songs = Song.all
    erb :'songs/index'
  end

  get '/songs/new' do
    erb :'songs/new'
  end

  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    erb :'songs/show'
  end

  post '/songs' do
    song = Song.create(params[:song])
    song.artist = Artist.find_or_create_by(params[:artist])
    song.save
    params[:genres].each do |id|
      genre = Genre.find_by_id(id)
      SongGenre.create(song_id: song.id, genre_id:genre.id)
    end

    flash[:message] = "Successfully created song."
    redirect to("/songs/#{song.slug}")
  end

  get '/songs/:slug/edit' do
    @song = Song.find_by_slug(params[:slug])
    erb :'songs/edit'
  end

  patch '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    @song.name = params[:song][:name]
    @song.artist = Artist.find_or_create_by(params[:artist])

    @song.genres.clear
    @song.save

    params[:genres].each do |id| 
      genre = Genre.find_by_id(id)
      SongGenre.create(song_id:@song.id, genre_id:genre.id)
    end

    flash[:message] = "Successfully updated song."
    redirect to("/songs/#{@song.slug}")
  end

end