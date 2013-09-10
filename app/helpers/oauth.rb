def oauth_consumer
  raise RuntimeError, "You must set TWITTER_KEY and TWITTER_SECRET in your server environment." unless ENV['TWITTER_KEY'] and ENV['TWITTER_SECRET']
  @consumer ||= OAuth::Consumer.new(
    ENV['TWITTER_KEY'],
    ENV['TWITTER_SECRET'],
    :site => "https://api.twitter.com"
  )
end

def request_token
  if not session[:request_token]
    # this 'host_and_port' logic allows our app to work both locally and on Heroku
    host_and_port = request.host
    host_and_port << ":9393" if request.host == "localhost"

    # the `oauth_consumer` method is defined above
    session[:request_token] = oauth_consumer.get_request_token(
      :oauth_callback => "http://#{host_and_port}/auth" 
      # Our app sends user away with a request token to verify with Twitter
        # this is route user gets directed to after authentication on Twitter
      # Twitter, here is the place to come back to after you're done authorizing user X
      # Our application checks if the redirect from Twitter is valid
         # App does this in routes /app. 
         # Twitter comes back to us with an oauth_verifier which is used in 'get_access_token' method to get the ACTUAL access token
    )
  end
  session[:request_token]
end
