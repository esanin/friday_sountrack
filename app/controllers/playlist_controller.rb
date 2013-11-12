# encoding: UTF-8
class PlaylistController < ApplicationController

  # Adds a video to a playlist
  def add_video

    # TODO: Move business logic to a model! Currently, this is not proper MVC.
    client = get_client

    # The default ordering is by date of creation (latests first)
    last_playlist = client.playlists.first
    last_date = Date.strptime(last_playlist.published, '%Y-%m-%d')

    unless Date.today.cweek == last_date.cweek
      last_playlist = client.add_playlist(title: "Friday Soundtrack, Week #{Date.today.cweek}")
    end

    unless params[:video].blank?
      video = nil

      if params[:video] =~ /(?:youtube.com|youtu.be).*(?:\/|v=)([a-zA-Z0-9_-]+)/
        video = $1
      else
        flash.alert = "Por favor ingresa un enlace válido"
      end
      unless video.nil?
        client.add_video_to_playlist(last_playlist.playlist_id, video)
        flash.notice = "¡Video añadido!"

      end
    else
      flash.alert = "Por favor ingresa un enlace a un video de youtube"
    end
    redirect_to root_path
  end

  # Shows this week's playlist. Creates it if it doesn't exist yet.
  def index
    client = get_client

    # The default ordering is by date of creation (latests first)
    last_playlist = client.playlists.first
    last_date = Date.strptime(last_playlist.published, '%Y-%m-%d')

    unless Date.today.cweek == last_date.cweek
      last_playlist = client.add_playlist(title: "Friday Soundtrack, Week #{Date.today.cweek}")
    end

    @playlist = last_playlist
    
    # Unexpectedly, the videos have to be loaded explicitely.
    # @videos = last_playlist.videos doesn't work.
    # this works, but I'm not using them yet @videos = client.playlist(last_playlist.playlist_id).videos

  end

  # Connects to YouTube.
  protected
  def get_client
    YouTubeIt::Client.new(username: YouTubeITConfig.username,
      password: YouTubeITConfig.password,
      dev_key: YouTubeITConfig.dev_key)
  end
end
