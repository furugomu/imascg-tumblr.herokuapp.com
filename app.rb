# -*- encoding: UTF-8 -*-

require 'rubygems'
require 'bundler/setup'
Bundler.require

class App < Sinatra::Base
  include Rack::Utils
  set :haml, format: :html5, escape_html: true
  configure do
    set :blog, 'imascg.tumblr.com'
    Tumblife.configure do |config|
      config.consumer_key = ENV['CONSUMER_KEY']
      config.consumer_secret = ENV['CONSUMER_SECRET']
      config.oauth_token = ENV['REQUEST_TOKEN']
      config.oauth_token_secret = ENV['REQUEST_TOKEN_SECRET']
    end
  end

  get '/' do
    haml :form
  end

  post '/create' do
    client = Tumblife.client
    begin
      result = client.create_post(settings.blog,
        type: 'photo',
        caption: escape_html(params[:caption]),
        data: params[:file][:tempfile].read)
      # できた投稿にリダイレクトする
      post = client.posts(settings.blog, id: result.id).posts[0]
      redirect post.post_url
    rescue Tumblife::Error => e
      @alert = e.message
      haml :form
    end
  end
end
