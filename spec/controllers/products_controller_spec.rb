require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  login_user

  let(:valid_attributes) do
    { code: 'PROD123', name: 'Test Product', price_in_currency: '19.95' }
  end

  let(:invalid_attributes) do
    { code: '', name: '', price_in_currency: '-10' }
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns all products as @products' do
      product = create(:product)
      get :index
      expect(assigns(:products).to_a).to include(product)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      product = create(:product)
      get :show, params: { id: product.id }
      expect(response).to be_successful
    end

    it 'assigns the requested product as @product' do
      product = create(:product)
      get :show, params: { id: product.id }
      expect(assigns(:product)).to eq(product)
    end
  end

  describe 'Admin-only actions' do
    login_admin

    describe 'GET #new' do
      it 'returns a success response' do
        get :new
        expect(response).to be_successful
      end

      it 'assigns a new product as @product' do
        get :new
        expect(assigns(:product)).to be_a_new(Product)
      end
    end

    describe 'GET #edit' do
      it 'returns a success response' do
        product = create(:product)
        get :edit, params: { id: product.id }
        expect(response).to be_successful
      end

      it 'assigns the requested product as @product' do
        product = create(:product)
        get :edit, params: { id: product.id }
        expect(assigns(:product)).to eq(product)
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new Product' do
          expect do
            post :create, params: { product: valid_attributes }
          end.to change(Product, :count).by(1)
        end

        it 'redirects to the products list' do
          post :create, params: { product: valid_attributes }
          expect(response).to redirect_to(products_path)
        end
      end

      context 'with invalid params' do
        it 'does not create a new Product' do
          expect do
            post :create, params: { product: invalid_attributes }
          end.not_to change(Product, :count)
        end

        it 'assigns a newly created but unsaved product as @product' do
          post :create, params: { product: invalid_attributes }
          expect(assigns(:product)).to be_a_new(Product)
        end

        it "re-renders the 'new' template" do
          post :create, params: { product: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template('new')
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) do
          { name: 'Updated Product', price_in_currency: '29.95' }
        end

        it 'updates the requested product' do
          product = create(:product)
          put :update, params: { id: product.id, product: new_attributes }
          product.reload
          expect(product.name).to eq('Updated Product')
        end

        it 'assigns the requested product as @product' do
          product = create(:product)
          put :update, params: { id: product.id, product: valid_attributes }
          expect(assigns(:product)).to eq(product)
        end

        it 'redirects to the products list' do
          product = create(:product)
          put :update, params: { id: product.id, product: valid_attributes }
          expect(response).to redirect_to(products_path)
        end

        it 'sets a success flash message' do
          product = create(:product)
          put :update, params: { id: product.id, product: valid_attributes }
          expect(flash[:notice]).to eq('Product successfully updated.')
        end
      end

      context 'with invalid params' do
        it 'assigns the product as @product' do
          product = create(:product)
          put :update, params: { id: product.id, product: invalid_attributes }
          expect(assigns(:product)).to eq(product)
        end

        it "re-renders the 'edit' template" do
          product = create(:product)
          put :update, params: { id: product.id, product: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template('edit')
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested product' do
        product = create(:product)
        expect do
          delete :destroy, params: { id: product.id }
        end.to change(Product, :count).by(-1)
      end

      it 'redirects to the products list' do
        product = create(:product)
        delete :destroy, params: { id: product.id }
        expect(response).to redirect_to(products_path)
      end

      it 'sets a success flash message' do
        product = create(:product)
        delete :destroy, params: { id: product.id }
        expect(flash[:notice]).to eq('Product successfully deleted.')
      end
    end
  end
end
