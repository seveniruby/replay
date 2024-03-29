require 'test_helper'

class ProxiesControllerTest < ActionController::TestCase
  setup do
    @proxy = proxies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:proxies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create proxy" do
    assert_difference('Proxy.count') do
      post :create, proxy: { bind_port: @proxy.bind_port, forward_ip: @proxy.forward_ip, forward_port: @proxy.forward_port, name: @proxy.name, protocol: @proxy.protocol }
    end

    assert_redirected_to proxy_path(assigns(:proxy))
  end

  test "should show proxy" do
    get :show, id: @proxy
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @proxy
    assert_response :success
  end

  test "should update proxy" do
    put :update, id: @proxy, proxy: { bind_port: @proxy.bind_port, forward_ip: @proxy.forward_ip, forward_port: @proxy.forward_port, name: @proxy.name, protocol: @proxy.protocol }
    assert_redirected_to proxy_path(assigns(:proxy))
  end

  test "should destroy proxy" do
    assert_difference('Proxy.count', -1) do
      delete :destroy, id: @proxy
    end

    assert_redirected_to proxies_path
  end
end
