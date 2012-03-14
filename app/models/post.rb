class Post
  YML = File.join(Rails.root,"config","config.yml")
  include ActiveAttr::Model

  attribute :name
  attribute :content
  attribute :published
  attribute :date
  attribute :url
  
  validates_presence_of :name, :content, :published
  
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
  
  
  def self.load_config(config=YML)
    @config = YAML.load_file(config)
  end
  
  def self.load_path
    @dir = [@config[Rails.env]["relative_blog_path"], @config[Rails.env]["posts_path"]].join("/")
  end
  
end