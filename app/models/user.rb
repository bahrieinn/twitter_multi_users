class User < ActiveRecord::Base


  def create_thread
    Twitter::Client.new(
      :oauth_token => self.oauth_token,
      :oauth_token_secret => self.oauth_secret
    )
  end

end
