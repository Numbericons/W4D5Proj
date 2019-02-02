require 'rails_helper'

RSpec.describe UsersController, type: :controller do
    describe 'GET#new' do 
        it 'renders the new user template' do
            get :new
            expect(response).to render_template(:new)
        end
    end

    describe 'POST#create' do 
        before(:each) do
            post :create, params: {user: {username: 'Bertha', password: 'password3'}}
        end
        context 'with valid params' do 
            it 'redirects to user\'s show page' do
             user1 = User.new(username: 'Bradley', password: 'password').save!
               expect(response).to redirect_to(user_url(user.id)) 
            end
            it 'logs in user' do 
                expect(session[:session_token]).to eq(User.last.session_token)
            end
        end

        context 'with invalid params' do 
            it 'renders a new template with errors' do
                expect(response).to render_template(:new)
                expect(flash[:errors]).to be_present
            end
              it 'doesn\'t logs in user' do 
                expect(session[:session_token]).not_to eq(User.last.session_token)
            end
        end
    end

    describe 'GET#show' do
        it 'renders the new user template' do
            user1 = User.new(username: 'Bradley', password: 'password').save!
            get :show, params:{id: user1.id}
            expect(response).to render_template(:show)
        end
    end

    describe 'GET#index' do
        it 'renders the main page' do 
            get :index 
            expect(response).to render_template(:index)
        end
    end 
end
