require 'sinatra'
require 'sinatra/reloader'
require "sinatra/activerecord"
require_relative 'models/contact'

get '/' do
  per_page = 5
  @page = params[:page] || 1
  @page = @page.to_i
  @search = params[:query]

  if @search
    @contacts = Contact.where("first_name ILIKE ? OR last_name ILIKE ?", @search, @search)
  else
    @contacts = Contact.limit(per_page).offset(per_page * (@page - 1))
  end

  erb :index
end

post '/' do
  Contact.create(first_name: params[:first_name], last_name: params[:last_name], phone_number: params[:phone_number])
  redirect '/'
end

get '/contacts/:id' do
  @contact = Contact.find(params[:id])
  erb :'contacts/show'
end
