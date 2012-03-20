class Post
  YML = File.join(Rails.root,"config","config.yml")
  
  include ActiveAttr::BasicModel
  include ActiveAttr::Attributes
  include ActiveAttr::AttributeDefaults
  include ActiveAttr::QueryAttributes
  include ActiveAttr::TypecastedAttributes
  include ActiveAttr::MassAssignment
  
  # attr_accessor :name, :content, :date, :url

  attribute :name, :type => String
  attribute :content, :type => String
  attribute :published, :default => 0, :type => Integer
  attribute :date, :type => String
  attribute :url, :type => String
  # Layout params
  attribute :categories, :type => String
  attribute :tags, :type => String
  attribute :comments, :default => 1, :type => Integer
  attribute :rss, :default => 1, :type => Integer
  
  validates_presence_of :name, :content, :published, :categories, :tags
  
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
        @post = p
      else
        puts "There is no Post with id => #{id.to_s}"
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