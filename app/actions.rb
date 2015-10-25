require 'literate_randomizer'

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
 
  def gen_sentance
    d = LiterateRandomizer.create({:source_material_file => "quotes.txt"})
    checker(d.sentence)
  end

  def checker(s)
    if s.split(" ").length > 3 && s.split(" ").length < 6
       s
    else
      gen_sentance
    end
  end


end

get '/history' do
 @user = User.where(cookie_id: current_user).first
 @captions_url_votes = Caption.where(user_id: @user.id)
 erb :'history'
end

get '/all' do
 @images = Caption.all
 erb :'all'
end


# Homepage (Root path)
get '/' do
  @photos = Image.order(:total_caption_votes).reverse
  erb :'index'
end

###########################################################
#As a user I can add a caption to a picture that already has captions

get '/images/:image_id/show' do
  @image = Image.find(params[:image_id])
  @user = User.where(cookie_id: current_user).first
  @sentance = gen_sentance
  x = @image.captions
  @y = x.order(:total_votes).reverse
  erb :'show'
end


get "/signup" do
  erb :"signup"
end

get "/logout" do
  cookies[:user_id] = nil
  redirect '/'
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
  image = Image.find{ |i| i.id == caption.image_id } 
  image.total_caption_votes += 1
  image.save
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
