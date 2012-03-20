require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Posts" do
  let(:user)  { Factory(:user) }
  
  before(:each) do
    Post.load_config(Post::YML)
    generate_posts(Post.load_path)
  end
  
  after(:each) do
    delete_posts(Post.load_path)
  end
  
  it "protects from unauthorized access" do
    visit(posts_path)
    current_path.should eq(login_path)
    page.should have_content("Not authorized")
  end
  
  it "grants access to authorized users" do
    visit(posts_path)
    current_path.should eq(login_path)
    login(user.email, user.password)
    current_path.should eq(root_path)
    page.should have_content("Logged in!")
    page.should have_content("Listing Posts")
  end
  
  it "lists posts" do
    login(user.email, user.password)
    page.should have_content("Listing Posts")
    within("table") do
      page.should have_content("First post")
      page.should have_content("2009/01/23")
      page.should have_content("2009-01-23-first-post.html")
    end
  end
  
  it "shows post" do
    login(user.email, user.password)
    page.should have_content("Listing Posts")
    within("table/tr[2]/td[4]") do
      click_link("Show")
    end
    page.should have_content("First post")
  end
  
  it "creates new post" do
    login(user.email, user.password)
    page.should have_content("Listing Posts")
    click_link("New Post")
    page.should have_content("New post")
    fill_in 'name', :with => 'New post'
  end
end
