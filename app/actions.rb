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
     # create user
   end
 end

 def current_user
   cookies[:user_id]
 end
end

get '/history' do
 @user = User.where(cookie_id: current_user).first
 @captions_url_votes = Caption.where(user_id: @user.id)
 erb :'history'
end

# Homepage (Root path)
get '/' do
  @photos = Image.order(:total_caption_votes).reverse
  @captions = 
  erb :'index'
end

###########################################################
#As a user I can add a caption to a picture that already has captions

get '/images/:image_id/show' do
  @image = Image.find(params[:image_id])
  @user = User.where(cookie_id: current_user).first
  x = @image.captions
  @y = x.order(:total_votes).reverse
  erb :'show'
end


get "/signup" do
  erb :"signup"
end

#A user can choose from a list of random pictures
get '/generate' do #Call Flickr API to return # images
 @photos = photos(1)
 erb :'generate'
end

#Save selected image to database
post '/generate/new' do
 @image = Image.new(url: params[:image])
 @image.save
 redirect "/images/#{@image.id}/show"
end


#Link up new caption with image and store in captions table

post '/images/:id/captions/new' do
  user = User.where(cookie_id: current_user).first
  @image = Image.find(params[:id])
  caption = @image.captions.new(text: params[:text], user_id: user.id)
  caption.save!
  redirect "/images/#{@image.id}/show"
end

post '/captions/vote/:id' do
  user = User.where(cookie_id: current_user).first
  vote = Vote.create(user_id: user.id, caption_id: params[:id])
  caption = Caption.find(params[:id])
  caption.total_votes += 1
  caption.save
  redirect "/images/#{caption.image_id}/show"
end

post "/signup" do
    cookies[:user_id] = SecureRandom.uuid
    user = User.new(name: params[:name],cookie_id: cookies[:user_id])
    user.save
    redirect "/generate"
  end
