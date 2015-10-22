

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

end


# Homepage (Root path)
get '/' do
  @photos = photos(1)
  # @images_top = Image.all.order(:total_votes).reverse
  # @images_recent = Image.all.order(:updated_at).reverse

  erb :index
end


# #will display the top captions based on total votes for the image
# get '/top/show' do
#   @title = 'Top Captions'
#   # @images = Image.all.order(total_votes: :desc)
#   @images_top = Image.all.order(:total_votes).reverse
#   #in index call index[0], [1], [2] for top 3
#   erb :'index'
# end

# #will display the most recent caption
# get '/recent/show' do
#   @title = 'Most Recent Captions'
#   @images_recent = Image.all.order(:updated_at).reverse
#   # @images = Image.all.order(updated_at: :desc)
#   erb :'index'
# end

#<form method="post" action="/submit">
# <button class="btn btn-lg btn-primary btn-block" type="submit" value="submit">Capjur it!</button>

#posts a new caption to a new picture or any picture. This caption command should work anywhere.
post 'show/caption/new' do
  @caption = Caption.new(
    text: params[:text]
  )
  if @caption.save
    redirect '/'
  else
    erb :'/show'
  end
end


#get for history page

#get for index page



#when image on the front page is clicked, it redirects to its already existing caption page
get '/image/:id' do  #/id means u need to pass :id into it using params[:id]
  @image = Image.find params[:id]
  erb :'/show'
end

# POST /submit HTTP/1.1
# CONTENT-LENGTH=54537
# BODY=email:this@that.com,password=something,text=slksjdfiuhwer

# GET /submit?email=this@that.com HTTP/1.1

# GET /submit/this@that.com

# '/submit/:email'

###########################################################
#As a user I can add a caption to a picture that already has captions
get '/images/:id/show' do

end
# POST: /images/:id/show/save
# Actions: Form text area with a submit action
# Save caption
###########################################################

####when exactly would these method activate???                            ??????????????
#A user can choose from a list of random pictures
get '/generate' do
  @photos = photos(1)
  erb :'generate' #Call Flickr API to return # images
end

#saves image to database?
post '/generate/new' do
  @image = Image.new(url: params[:image])  #the image from the view (which calls the API method) returns an html 
  @image.save #which we put into :image which we pass into url
  erb :'show'
end

