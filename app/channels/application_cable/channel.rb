# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
module ApplicationCable
  class Channel < ActionCable::Channel::Base
    delegate :session, :ability, to: :connection
    # dont allow the clients to call those methods
    protected :session, :ability
  end
end
