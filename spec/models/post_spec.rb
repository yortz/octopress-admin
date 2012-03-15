require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Post do
  
  context "Post Configuration" do
    
    it  { should have_attribute(:name).of_type(String) }
    it  { should have_attribute(:date).of_type(String) }
    it  { should have_attribute(:url).of_type(String) }
    it  { should have_attribute(:published).of_type(Integer).with_default_value_of(0) }
    it  { should have_attribute(:categories).of_type(String) }
    it  { should have_attribute(:tags).of_type(String) }
    it  { should have_attribute(:comments).of_type(Integer).with_default_value_of(1) }
    it  { should have_attribute(:rss).of_type(Integer).with_default_value_of(1) }
  
    it "initializes config yml" do
      config = Post.load_config(Post::YML)
      config[Rails.env]["relative_blog_path"].should eq("/Users/yortz/projects/octopress-admin/spec/data/blog/source") 
    end
  
    it "initializes posts path" do
      path = Post.load_path
      path.should eq("/Users/yortz/projects/octopress-admin/spec/data/blog/source/_posts")
    end
    
  end
  
  context "Post" do
    
    before(:each) do
      generate_posts(Post.load_path)
    end
    
    after(:each) do
      delete_posts(Post.load_path)
    end
    
    it "returns a list of the posts" do
      get_posts
      @posts.count.should eq(3)
      @posts.first.class.should eq(Hash.new.class)
      @posts.first.should eq({:id=>0, :date=>"2009/01/23", :title=>"First post", :url=>"2009-01-23-first-post.html"})
      @posts.first[:date].should eq("2009/01/23")
      @posts.first[:title].should eq("First post")
      @posts.first[:url].should eq("2009-01-23-first-post.html")
    end
    
    it "finds the post by id" do
      id = "0"
      @post = Post.find(id)
      @post[:title].should eq("First post")
    end
  
    it "creates new post" do
      new_post("new post", "2001-03-14", "<p>This is a <a href=\"http://google.com\">link<a/> post</p>", "events", "great, awesome, even better")
      @post.name.should eq("new post")
      @post.date.should eq("2001-03-14")
      @post.content.should eq("<p>This is a <a href=\"http://google.com\">link<a/> post</p>")
      @post.published.should eq(0)
      @post.url.should eq("/Users/yortz/projects/octopress-admin/spec/data/blog/source/_posts")
      @post.categories.should eq("events")
      @post.tags.should eq("great, awesome, even better")
    end
  
    it "saves new post and creates the post in the correct folder" do
      new_post("new post", "2001-03-14", "<p>This is a <a href=\"http://google.com\">link<a/> post</p>", "events", "great, awesome, even better")
      @post.save
      @post = Post.find(0)
      @post[:title].should eq("New post")
    end
  end
  
end