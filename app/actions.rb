helpers do

  def photos(n)
    recent = flickr.photos.getRecent(per_page: n)
      recent.map do |photo|
        info = flickr.photos.getInfo photo_id: photo.id
        FlickRaw.url(info)
      end
  end


  def require_user_cookie
    if !cookies[:user_id]
      cookies[:user_id] = SecureRandom.uuid
      @user = User.new(cookie_id: cookies[:user_id])
      @user.save
      # create user
    end
  end

  def user_captions_url
    require_user_cookie
    User.where(cookie_id: current_user).first
    @user = User.where(cookie_id: current_user).first
    captions = Caption.where(user_id: @user.id)
    array = []
    captions.each do |c|
      array << Image.find(c.image_id).url
      array << c.text
    end
    @captions_url = Hash[*array.flatten]
    @captions_url
  end

  def current_user

    cookies[:user_id]
  end

end

get '/history' do
  require_user_cookie
  @captions_url = user_captions_url
  erb :'history'
end

# Homepage (Root path)
get '/' do
  require_user_cookie
  @photos = Image.all.order(:created_at).reverse
  erb :'index'
end

###########################################################
#As a user I can add a caption to a picture that already has captions

get '/images/:image_id/show' do
   @image = Image.find(params[:image_id])
  erb :'show'
end

get '/images/:id/show' do
require_user_cookie
end

#As a user I can add a caption to a picture that already has captions
get '/images/show' do
  require_user_cookie
  @image = Image.last
  erb :'show'
end

#A user can choose from a list of random pictures
get '/generate' do
  require_user_cookie
  @photos = photos(1)
  erb :'generate' #Call Flickr API to return # images
end

#Save selected image to database
post '/generate/new' do
  require_user_cookie
  @image = Image.new(url: params[:image])
  @image.save
 redirect '/images/show'
end


#Link up new caption with image and store in captions table

post '/images/:id/captions/new' do
  # binding.pry
  image = Image.find(params[:id])
  caption = image.captions.new(text: params[:text])
  caption.save!
  redirect 'images/show'
end


post '/images/caption/new' do
  require_user_cookie
  @caption = Caption.new(
    user_id: cookies[:user_id],
    text: params[:text],
    image_id: params[:image_id],
    )
  @caption.save
 redirect '/'
end



post '/captions/vote' do
  require_user_cookie
  caption = Caption.find(params[:id])
  caption.total_upvotes += 1
  caption.save
  Vote.create(user_id: cookies[:user_id], caption_id: params[:id])
end
