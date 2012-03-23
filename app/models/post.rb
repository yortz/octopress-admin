class Post
  YML = File.join(Rails.root,"config","config.yml")
  
  include ActiveAttr::BasicModel
  include ActiveAttr::Attributes
  include ActiveAttr::AttributeDefaults
  include ActiveAttr::QueryAttributes
  include ActiveAttr::TypecastedAttributes
  include ActiveAttr::MassAssignment
  
  # attr_accessor :name, :content, :date, :url
  
  attribute :id, :type => Integer
  attribute :name, :type => String
  attribute :content, :type => String
  attribute :published, :default => 0, :type => Integer
  attribute :year, :type => Integer
  attribute :month, :type => Integer
  attribute :day, :type => Integer
  attribute :url, :type => String
  # Layout params
  attribute :categories, :type => String
  attribute :tags, :type => String
  attribute :comments, :default => 1, :type => Integer
  attribute :rss, :default => 1, :type => Integer
  
  validates_presence_of :name, :content, :categories, :tags, :year, :month, :day
  
  def initialize(attributes = {})
    super
    Post.load_config
    @url = Post.load_path
    self.url = @url
  end
  
  def date
    [self.year, (sprintf '%02d', self.month), (sprintf '%02d', self.day)].join("-")
  end
  
  def self.all
    @posts = []
    Dir[File.join(@dir, "*.html")].each_with_index do |file, i|
      @posts << { id: i,
                  date: File.basename(file).scan(/\d+-/).join("/").gsub!(/-/,""),
                  title: File.basename(file).split(/- */, 4).last.capitalize.gsub!(/\.html/, "").gsub!(/-/, " "), 
                  url: [@dir, File.basename(file)].join("/")}
    end
    return @posts
  end
  
  def self.find(id)
    @posts = self.all
    @posts.find do |p|
      if p[:id]  == id.to_i
        @post = Post.new
        @post.url = [@post.url, p[:url].gsub!(/(\/)+(\D*)/, "")].join("/")
        @post.id = p[:id].to_i
        @post.year = p[:date].split("-").first
        @post.month = p[:date].split("-")[1]
        @post.day = p[:date].split("-").last
        @post.name = p[:title]
        return @post
      end
    end
  end
  
  def save
    filename = "#{self.url}/#{self.date}-#{self.name.to_url}.html"
    unless File.exist?(filename)
      #puts "Creating new post: #{filename}"
      open(filename, 'w') do |post|
        post.puts "---"
        post.puts "layout: post"
        post.puts "title: \"#{self.name.gsub(/&/,'&amp;')}\""
        post.puts "date: #{self.date}"
        post.puts self.comments == 1 ? "comments: true" : "comments: false"
        post.puts self.rss == 1 ? "rss: true" : "rss: false"
        post.puts "categories: #{self.categories}"
        post.puts "tags:\n- #{self.tags.gsub(/,/, "\n-")}"
        post.puts "---"
        post.puts "\n"
        post.puts "#{self.content}"
      end
    end
  end
  
  def destroy
    #puts "Deleting post: #{self.url}"
    File.delete(self.url)
  end
  
  def self.load_config(config=YML)
    @config = YAML.load_file(config)
  end
  
  def self.load_categories
     @categories = []
     [@config["categories"]].each { |category| category.each {|h| h.each {|k,v| @categories << v } }}
     return @categories
  end
  
  def self.load_path
    @dir = [@config[Rails.env]["relative_blog_path"], @config[Rails.env]["posts_path"]].join("/")
  end
  
end