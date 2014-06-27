require 'rails_helper'

describe UrlsController do
  describe "POST create" do
    context 'a new url is submitted with a shortened extension' do
      subject { post :create, url: { original_url: "http://facebook.com", shortened_extension: "fb" } }

      it 'will create a new url object' do
        expect{ subject }.to change(Url, :count).by 1
        expect(Url.last.original_url).to eq "http://facebook.com"
      end

      it 'will set the custom shortened extension' do
        subject
        expect(Url.last.shortened_extension).to eq "fb"
      end

      it 'will redirect to show page when successfully created' do
        subject
        expect(response).to redirect_to url_path(Url.find_by(shortened_extension: "fb"))
      end
    end

    context 'a new url is submitted without a custom extension' do
      subject { post :create, url: { original_url: "http://google.com" } }

      it 'will create a new url object' do
        expect { subject }.to change(Url, :count).by 1
        expect(Url.last.original_url).to eq "http://google.com"
      end

      it 'will randomly set a shortened extension' do
        subject
        expect(Url.last.shortened_extension).to be_present
      end
    end

    context 'a duplicate url is submitted' do
      fb_attributes = { original_url: "http://facebook.com", shortened_extension: "fb"}
      let!(:first_url){ Url.create(fb_attributes) }
      subject { post :create, url: fb_attributes }

      it 'will redirect to the show page, but show the already-shortened url' do
        subject
        expect(response).to redirect_to url_path(Url.find_by(shortened_extension: "fb" ))
        expect(flash[:notice]).to match /We've already redirected this url/
      end

      it 'will use the original shortened extension' do
        post :create, url: { original_url: "http://facebook.com", shortened_extension: 'fbook' }
        expect(Url.find_by(original_url: "http://facebook.com").shortened_extension).to eq ("fb")
      end
    end

    context 'a duplicate shortened extension is submitted' do

      let!(:first_url){ Url.create(original_url: "http://google.com", shortened_extension: "goog") }
      subject { post :create, url: { original_url: "http://guggenheim.org", shortened_extension: "goog"}}

      it 'will re-render the new action' do
        subject
        expect(response).to render_template :new
      end

      it 'the object will have errors' do
        subject
        expect(assigns(:url).errors.count).to eq 1
      end
    end
  end

  describe 'GET new' do
    it 'will render the new action' do
      expect(get :new).to render_template :new
    end
  end

  describe 'GET show' do
    let(:url) { Url.create(original_url: "http://google.com", shortened_extension: "goog")}
    subject { get :show, id: url.id }
    it 'will render the show action' do
      expect(subject).to render_template :show
    end
  end

  describe 'GET redirect' do
    let(:url) { Url.create(original_url: "http://google.com", shortened_extension: "goog") }
    subject { get :redirect, shortened_extension: url.shortened_extension }

    it 'should redirect the user to the original_url' do
      subject
      expect(response).to redirect_to url.original_url

    end
  end
end