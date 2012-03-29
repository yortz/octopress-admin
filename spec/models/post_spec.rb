require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Post do
  
  context "Post Configuration" do
    
    it  { should have_attribute(:id).of_type(Integer) }
    it  { should have_attribute(:name).of_type(String) }
    it  { should have_attribute(:year).of_type(Integer) }
    it  { should have_attribute(:month).of_type(Integer) }
    it  { should have_attribute(:day).of_type(Integer) }
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
    
    it "initializes the categories from the config file" do
      categories = Post.load_categories
      categories[1].should eq("news")
      categories.size.should eq(3)
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
      @posts = Post.all
      @posts.count.should eq(3)
      @posts.first.class.should eq(Hash.new.class)
      @posts.first.should eq({ :id=>0, 
                               :date=>"2009/01/23", 
                               :title=>"First post", 
                               :url=>"/Users/yortz/projects/octopress-admin/spec/data/blog/source/_posts/2009-01-23-first-post.html",
                               :published => 1 })
      @posts.first[:date].should eq("2009/01/23")
      @posts.first[:title].should eq("First post")
      @posts.first[:url].should eq("/Users/yortz/projects/octopress-admin/spec/data/blog/source/_posts/2009-01-23-first-post.html")
      @posts.first[:published].should eq(1)
    end
    
    it "finds the post by id" do
      id = "0"
      @post = Post.find(id)
      @post.name.should eq("First post")
      @post.id.should eq(0)
      @post.url.should eq("/Users/yortz/projects/octopress-admin/spec/data/blog/source/_posts/2009-01-23-first-post.html")
      @post.categories.should eq("news")
      @post.tags.should eq("news, events")
      @post.rss.should eq(1)
      @post.comments.should eq(1)
      @post.published.should eq(1)
      @post.content.should eq("<html><body>\n<h1>First post</h1>\n<p>Some dummy content with html <a href=\"http://google.com\" target=\"_blank\">link.</a></p>\n</body></html>")
    end
      
    it "creates new post" do
      @categories = Post.load_categories
      new_post("new post", "2001-03-14", "<p>This is a <a href=\"http://google.com\">link<a/> post</p>", "#{@categories.last}", "great, awesome, even better")
      @post.name.should eq("new post")
      @post.date.should eq("2001-03-14")
      @post.content.should eq("<p>This is a <a href=\"http://google.com\">link<a/> post</p>")
      @post.published.should eq(0)
      @post.url.should eq("/Users/yortz/projects/octopress-admin/spec/data/blog/source/_posts")
      @post.categories.should eq("photocontest")
      @post.tags.should eq("great, awesome, even better")
    end
      
    it "saves new post and creates the post in the correct folder" do
      @categories = Post.load_categories
      new_post("new post", "2001-03-14", "<p>This is a <a href=\"http://google.com\">link<a/> post</p>", "#{@categories.first}", "great, awesome, even better")
      @post.save
      @post = Post.find(0)
      @post.name.should eq("New post")
    end
    
    it "deletes an unpuplished post" do
      @post = Post.find(1)
      @post.destroy
      @posts = Post.all
      @posts.count.should eq(2)
    end
    
    it "updates a post" do
      @post = Post.find(1)
      values = { name: "edit test post",
                 year: "2012", 
                 month: "3",
                 day: "29", 
                 content: "<html><body>this is an edit content</body></html>",
                 categories: "events",
                 tags: "photocontest",
                 published: 0,
                 comments: 1,
                 rss: 1}
      @post.update_attributes(values)
      @post.name.should eq("edit test post")
      @post.content.should eq("<html><body>this is an edit content</body></html>")
      @post.categories.should eq("events")
      @post.tags.should eq("photocontest")
      @post.url.should eq("/Users/yortz/projects/octopress-admin/spec/data/blog/source/_posts/2012-03-29-edit-test-post.html")
    end
    
  end
  
end