class Post
  YML = File.join(Rails.root,"config","config.yml")
  
  include ActiveAttr::BasicModel
  include ActiveAttr::Attributes
  include ActiveAttr::AttributeDefaults
  include ActiveAttr::QueryAttributes
  include ActiveAttr::TypecastedAttributes
  include ActiveAttr::MassAssignment
  
  #attr_accessor :name, :content, :date, :url
  
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
                  url: [@dir, File.basename(file)].join("/"),
                  published: File.exists?([ @publish_path, 
                                             File.basename(file).scan(/\d+-/).join("/").gsub!(/-/,"").split("/"),
                                             File.basename(file).split(/- */, 4).last.gsub!(/\.html/, ""),
                                             "index.html"].join("/")) ? 1 : 0 }
    end
    return @posts
  end
  
  def self.find(id)
    posts = self.all
    posts.find do |p|
      if p[:id]  == id.to_i
        @post = Post.new
        @post.url = [@post.url, p[:url].gsub!(/(\/)+(\D*)/, "")].join("/")
        @post.id = p[:id].to_i
        @post.year = p[:date].split("/").first
        @post.month =  p[:date].split("/")[1]
        @post.day = p[:date].split("/").last
        @post.name = p[:title]
        @post.published = p[:published]
        Post.load(@post)
      end
    end
    return @post
  end
  
  
  def self.load(post)
    doc = Nokogiri::HTML(open(post.url))
    yaml_front_matter = doc.xpath("//p").text.split(/-{3}/)[1]
    layout = yaml_front_matter.scan(/layout:\s\w*/)[0].gsub(/layout:/, "")
    post.categories = yaml_front_matter.scan(/categories:\s\w*/)[0].gsub(/categories:/,"").strip!
    post.tags = yaml_front_matter.scan(/^-\W*+.*/).each {|t| t.gsub!(/-/,"").strip! }.join(", ")
    rss = yaml_front_matter.scan(/rss:\s\w*/)[0].gsub(/rss:/,"").strip!
    rss == "true" ? post.rss = 1 : post.rss = 0
    comments = yaml_front_matter.scan(/comments:\s\w*/)[0].gsub(/comments:/,"").strip!
    comments == "true" ? post.comments = 1 : post.comments = 0
    doc.xpath("//p[1]").first.remove #remove the yaml front matter incapsulated in <p> tag by default
    doc.children.each {|p| post.content = p} # cycle through remaining nodes
  end
  
  
  def save
    filename = "#{self.url}/#{self.date}-#{self.name.to_url}.html"
    unless File.exist?(filename)
      #puts "Creating new post: #{filename}"
      write(filename)
    end
  end
  
  
  def update_attributes(values)
    values.each { |k,v| self.send "#{k}=", v }
    temp_file = Tempfile.new("#{self.date}-#{self.name.to_url}.html")
    write(temp_file)
    FileUtils.mv(temp_file.path, self.url)
    new_file_name = "#{self.url.gsub(/\/{1}\d.*./, '')}/#{self.date}-#{self.name.to_url}.html"
    File.rename(self.url, new_file_name )
    self.url = new_file_name
    # values.each { |k,v| self.send "#{k}=", v }
    # destroy
    # filename = "#{self.url.gsub(/\/{1}\d.*./, '')}/#{self.date}-#{self.name.to_url}.html"
    # write(filename) unless File.exist?(filename)
    # self.url = filename
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
  
  def self.published_path
    @publish_path = @config[Rails.env]["published_path"]
  end
  
  private
    
    def write(filename)
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