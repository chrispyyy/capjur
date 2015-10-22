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
  erb :index
end
