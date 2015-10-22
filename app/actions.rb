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
  erb :'index'
end
###########################################################
#As a user I can add a caption to a picture that already has captions
get '/images/:id/show' do

end
# POST: /images/:id/show/save
# Actions: Form text area with a submit action
# Save caption
###########################################################

#A user can choose from a list of random pictures
get '/generate' do
  @photos = photos(8)
  erb :'generate' #Call Flickr API to return # images
end 


post '/generate/new' do
  @image = Image.new(
    url: params[:url],
  )
  @image.save
    erb :'caption'
end
    #Form submit button



