
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

# Homepage (Root path)
get '/' do
  erb :index
end

#will display the top captions based on total votes for the image
get '/top/:id/show' do
  @title = 'Top Captions'
  # @images = Image.all.order(total_votes: :desc)
  @images = Image.by_total_votes.limit(3)
  binding.pry
  erb :'index'
end

#will display the most recent caption
get '/recent/:id/show' do
  @title = 'Most Recent Captions'
  @images = Image.all.order(updated_at: :desc)
  erb :'index'
end

#<form method="post" action="/submit">
# <button class="btn btn-lg btn-primary btn-block" type="submit" value="submit">Capjur it!</button>

#posts a new caption to a new picture or any picture. This caption command should work anywhere.
post '/submit' do
  @caption = Caption.new(
    text: params[:text],
  )
  if @caption.save
    redirect '/'
  else
    erb :'/show'
  end
end


#when image on the front page is clicked, it redirects to its already existing caption page
get '/image/:id' do
  @image = Image.find params[:id]
  erb :'/show'
end



#