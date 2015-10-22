helpers do

  def photos(n)
    recent = flickr.photos.getRecent(per_page: n)
      recent.map do |photo|
        info = flickr.photos.getInfo photo_id: photo.id
        FlickRaw.url(info)
      end
  end

  def current_user
    if cookies[:user_id]
      User.find(cookies[:user_id])
    end
  end

end

# Homepage (Root path)
get '/' do
  @photos = Image.all.order(:created_at).reverse
  erb :'index'
end

###########################################################
#As a user I can add a caption to a picture that already has captions
get '/images/:id/show' do

end

#As a user I can add a caption to a picture that already has captions
get '/images/show' do
  @image = Image.last
  erb :'show'
end

#A user can choose from a list of random pictures
get '/generate' do
  @photos = photos(1)
  erb :'generate' #Call Flickr API to return # images
end

#Save selected image to database
post '/generate/new' do
  binding.pry
  @image = Image.new(url: params[:image])
  @image.save
 redirect '/images/show'
end


#Link up new caption with image and store in captions table
post '/images/caption/new' do
  @caption = Caption.new(
    text: params[:text],
    image_id: params[:image_id],
    )
  @caption.save
 redirect '/'
end

post '/captions/vote' do
  caption = Caption.find(params[:id])
  caption.total_upvotes += 1
  caption.save
  Vote.create(user_id: 1, caption_id: params[:id])
end
