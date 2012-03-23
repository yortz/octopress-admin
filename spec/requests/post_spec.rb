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
    click_link("New Post")
    fill_in 'Name', :with => 'My new post title'
    fill_in 'Content', :with => '<p>Some dummy content with <a href="http://google.com" target="_blank">link.</a></p>'
    fill_in 'Tags', :with => "tag1, tag2, tag3"
    select '2012', :from => 'post[year]'
    select '6', :from => 'post[month]'
    select '22', :from => 'post[day]'
    select 'photocontest', :from => 'Categories'
    click_button 'Create Post'
    #@post.name.should eq("My new post title")
    # page.should have_content("First post")
    # page.should have_content("Second post")
    # page.should have_content("Third post")
    # page.should have_content("My new post title")
  end
end
