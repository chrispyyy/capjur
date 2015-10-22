

# helpers do # methods defined here are available in the .erb files, actions.rb and templates in the app
  
#   def logged_in?
#     !!current_user
#   end

#   def current_user
#     if session[:user_id]
#       User.find(session[:user_id])
#     end
#   end
# end

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

# helpers do

#   def photos(n)
#     recent = flickr.photos.getRecent(per_page: n)
#       recent.map do |photo|
#         info = flickr.photos.getInfo photo_id: photo.id
#         FlickRaw.url(info)
#       end
#   end

#   def current_user
#     if cookies[:user_id]
#       User.find(cookies[:user_id])
#     end
#   end

# end

# Homepage (Root path)
get '/' do
  @photos = Image.all.order(:created_at).reverse
  erb :'index'
end

###########################################################
#As a user I can add a caption to a picture that already has captions
get '/images/:image_id/show' do 
  @image = Image.find(params[:image_id])
   erb :'show'
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

# # Homepage (Root path)
# get '/' do
#   @photos = photos(1)
#   erb :'/index'
# end

# # @images_top = Image.all.order(:total_votes).reverse
#   # @images_recent = Image.all.order(:updated_at).reverse

# #posts a new caption to a new picture or any picture. This caption command should work anywhere.
# # post '/show/caption/new' do
# #   @caption = Caption.new(
# #     text: params[:text]

# #   )
# #   if @caption.save
# #     redirect '/'
# #   else
# #     erb :'/show'
# #   end
# # end


# #get for history page

# #get for index page

# #   @photos = Image.all.order(:created_at).reverse
# #   erb :'index'
# # end

# ###########################################################
# #As a user I can add a caption to a picture that already has captions
# get '/images/:id/show' do

# end

# # POST /submit HTTP/1.1
# # CONTENT-LENGTH=54537
# # BODY=email:this@that.com,password=something,text=slksjdfiuhwer

# # GET /submit?email=this@that.com HTTP/1.1

# # GET /submit/this@that.com

# ###########################################################
# #As a user I can add a caption to a picture that already has captions
# # get '/images/:id/show' do
# # >>>>>>> 614c18f9a98d33a27b011b2c2c9a8c86a3478ce6

# ####when exactly would these method activate???                            ??????????????
# #A user can choose from a list of random pictures
# get '/generate' do
#   @photos = photos(1)
#   erb :'/generate' #Call Flickr API to return # images
# end

# #As a user I can add a caption to a picture that already has captions
# get '/images/show' do
#   @image = Image.last
#   erb :'show'
# end
# # #saves image to database?
# # post '/generate/new' do
# #   @image = Image.new(url: params[:image])  #the image from the view (which calls the API method) returns an html 
# #   @image.save #which we put into :image which we pass into url
# #   erb :'show'
# # end

# #Save selected image to database
# post '/images' do
#   @image = Image.create(url: params[:image])
#  redirect "/images/#{@image.id}/show"
# end

# #when image on the front page is clicked, it redirects to its already existing caption page
# get '/images/:image_id/show' do  #/id means u need to pass :id into it using params[:id]
#   @image = Image.find params[:image_id]
#   # @caption = Caption.new
#   erb :'/show'
# end



# get '/images/:image_id' do
#   @image = Image.find(params[:image_id])
#   # render erb :'image'
# end

# #Link up new caption with image and store in captions table
# post '/images/:image_id/captions' do
#   @caption = Caption.create(
#     user_id: 1,
#     text: params[:text],
#     image_id: params[:image_id],
#     )
#  redirect '/images/show'
# end


# post '/captions/vote' do
#   caption = Caption.find(params[:id])
#   caption.total_upvotes += 1
#   caption.save
#   Vote.create(user_id: 1, caption_id: params[:id])
# end

