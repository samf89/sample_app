require 'test_helper'

class MicropostInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:test_user_one)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]' 
    # Invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, micropost: { content: "" }
    end
    assert_select 'div#error_explanation'
    # Valid submission
    content = "This is the content for the micropost, overdone Big Lebowski reference"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, micropost: { content: content }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # Delete a post
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # Visit a different user
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end
  
  test "micropost interface with image upload" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]' 
    # Valid submission with image upload
    content = "This is a micropost"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, micropost: { content: content, picture: picture }
    end
    # Obtain the micropost from the controller (create action)
    micropost = assigns(:micropost)
    assert micropost.picture?
  end

  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match '34 microposts', response.body # see fixtures for the exact number
    other_user = users(:mallory)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "This is a micropost!")
    get root_path
    assert_match "1 micropost", response.body
  end
end
