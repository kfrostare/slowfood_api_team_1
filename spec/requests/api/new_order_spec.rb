# frozen_string_literal: true
RSpec.describe Api::OrdersController, type: :request do
  let!(:product_1) { create(:product, name: 'Salad', price: 10) }
  let!(:product_2) { create(:product, name: 'Ice Cream', price: 20) }
  
  before do
    post '/api/orders', params: { product_id: product_1.id }
    order_id = (response_json)['order']['id']
    @order = Order.find(order_id)
  end
  
  describe 'POST /api/orders' do
    it 'responds with success message' do
      expect((response_json)['message']).to eq 'This item has been added to your order.'
    end
    it 'responds with order id' do
      expect((response_json)['order']['id']).to eq @order.id
    end
    it 'responds with right amount of products' do
      expect((response_json)['order']['products'].count).to eq 1
		end
		it 'responds with right order total' do
      expect((response_json)['order']['total']).to eq 10
    end
  end

  describe 'PUT /api/orders/:id' do
    before do
      put "/api/orders/#{@order.id}", params: { product_id: product_2.id }
      put "/api/orders/#{@order.id}", params: { product_id: product_2.id }
    end
    it 'adds another product to order if request is a PUT and param id of the order is present' do
      expect(@order.order_items.count).to eq 3
    end
    it 'responds with order id' do
      expect((response_json)['order']['id']).to eq @order.id
    end
    it 'responds with right amount of unique products' do
      expect((response_json)['order']['products'].count).to eq 2
    end
    it 'responds with right order total' do
      expect((response_json)['order']['total']).to eq 50
    end
  end
end