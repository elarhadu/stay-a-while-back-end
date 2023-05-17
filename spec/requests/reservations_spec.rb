require 'rails_helper'
# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
RSpec.describe '/reservations', type: :request do
  before(:example) do
    @user = User.create(name: 'test2')
    @home_stay = HomeStay.create(name: 'test', location: 'test', description: 'test', no_of_rooms: 1, rating: 1,
                                 price: 1, user_id: @user.id)
    @reservation = Reservation.create(no_of_persons: 1, start_date: '2021-05-01', end_date: '2021-05-02',
                                      home_stay_id: @home_stay.id, user_id: @user.id)
    post '/login', params: { name: 'test2' }
    @response_body = JSON.parse(response.body, symbolize_names: true)
  end
  let(:header) do
    { Authorization: "Bearer #{@response_body[:token]}" }
  end
  describe 'GET /index' do
    before(:example) do
      get reservations_url, headers: header, as: :json
    end
    it 'renders a successful response' do
      expect(response).to be_successful
    end
    it 'renders a JSON response with the new reservation' do
      expect(response.content_type).to match(a_string_including('application/json'))
    end
  end
  describe 'POST /create' do
    before(:example) do
      post reservations_url,
           params: { reservation: { home_stay_id: @home_stay.id, no_of_persons: 1,
                                    start_date: '2021-05-01',
                                    end_date: '2021-05-02' } },
           headers: header, as: :json
    end
    it 'creates a new Reservation' do
      expect(Reservation.count).to eq(2)
    end
    it 'request status is 201' do
      expect(response).to have_http_status(:created)
    end
    it 'renders a JSON response with the new reservation' do
      expect(response.content_type).to match(a_string_including('application/json'))
    end
  end
  describe 'destroy' do
    before(:example) do
      delete reservation_url(@reservation), headers: header, as: :json
    end
    it 'destroys the requested reservation' do
      expect(Reservation.count).to eq(0)
    end
    it 'request status is 204' do
      expect(response).to have_http_status(:success)
    end
  end
end
