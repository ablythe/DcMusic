class SpotifyApi
  def initialize( user_id:'DcMusic')
    @secret = Rails.application.secrets.spotify_secret
    @client_id = Rails.application.secrets.spotify_client_id
  end

  def retrieve_auth_token
    auth = "Basic #{Base64.strict_encode64("#{@client_id}:#{@secret}")}"
    response = HTTParty.post('https://accounts.spotify.com/api/token',
      body: {grant_type:'client_credentials'},
      headers: {'Content-Type' => 'application/x-www-form-urlencoded',
                Authorization: auth
               }
      )
    @token = response['access_token']
  end

  def search_for_artist(artist)
    response = get('https://api.spotify.com/v1/search', { q: artist, type: 'artist', limit: 1})
    data = response['artists']['items']
    if data.length > 0
      return {artist: data[0]["name"], spotify_id: data[0]["id"]}
    else
      return false
    end
  end

  def fetch_top_track(artist_id)
    response = get("https://api.spotify.com/v1/artists/#{artist_id}/top-tracks", {market: 'US'})
    first_track = response['tracks'][0]
    return {uri: first_track['uri'], name: first_track['name']}
  end

  def get(endpoint, query = {})
    HTTParty.get(endpoint,
      query: query,
      headers: { Authorization: "Bearer #{@token}" }
    )
  end
end
