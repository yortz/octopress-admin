require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Post do
  
  it "initializes config yml" do
    config = Post.load_config(Post::YML)
    config[Rails.env]["relative_blog_path"].should eq("/Users/yortz/projects/octopress-admin/spec/data/blog/source") 
  end
  
  it "initializes posts path" do
    path = Post.load_path
    path.should eq("/Users/yortz/projects/octopress-admin/spec/data/blog/source/_posts")
  end
  
  it "returns a list of the posts" do
    @posts = []
    Dir[File.join(Post.load_path, "*.html")].each_with_index do |file, i|
      @posts << { id: i,
                  date: File.basename(file).scan(/\d+-/).join("/").gsub!(/-/,""),
                  title: File.basename(file).split(/- */, 4).last.capitalize.gsub!(/\.html/, "").gsub!(/-/, " "), 
                  url: File.basename(file)}
    end
    @posts.count.should eq(3)
    @posts.first.class.should eq(Hash.new.class)
    @posts.first.should eq({:id=>0, :date=>"2009/01/23", :title=>"First post", :url=>"2009-01-23-first-post.html"})
    @posts.first[:date].should eq("2009/01/23")
    @posts.first[:title].should eq("First post")
    @posts.first[:url].should eq("2009-01-23-first-post.html")
  end
  
end