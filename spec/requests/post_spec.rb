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
    page.should have_content("Some dummy content with html")
  end
  
  it "shows new post" do
    login(user.email, user.password)
    page.should have_content("Listing Posts")
    click_link("New Post")
    page.should have_content("New post")
    page.should have_content(Time.now.year)
    page.should have_content(Time.now.month)
    page.should have_content(Time.now.day)
    find("#post_published")[:checked].should eq(false)
    find("#post_comments")[:checked].should eq(true)
    find("#post_rss")[:checked].should eq(true)
  end
  
  it "creates post" do
    login(user.email, user.password)
    create_post
    within("table") do
      page.should have_content("My new post title")
      page.should have_content("2012/06/22")
      page.should have_content("2012-06-22-my-new-post-title.html")
    end
  end
  
  # it "deletes a specific post", :js => true do
  #   login(user.email, user.password)
  #   create_post
  #   page.should have_selector('table tr', :count => 5)
  #   click_link("Delete")
  #   page.driver.browser.switch_to.alert.accept
  #   page.should_not have_content("First post")
  #   page.should_not have_content("2009/01/23")
  #   page.should_not have_content("2009-01-23-first-post.html")
  #   page.should have_selector('table tr', :count => 4)
  # end
  
  it "updates a post" do
    login(user.email, user.password)
    click_link("Edit")
    page.should have_content("Edit post")
    within("form") do
      page.should have_content("First post")
    end
    fill_in 'Name', :with => 'Edit my first post'
  end
end
