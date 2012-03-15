module PostMacros
  
POSTS = [["2009-01-23-first-post.html", { yml_frontmatter: %Q{--- 
layout: post
title: First Post
categories: news
rss: true
comments: true
tags:
- news
- events
---},
content: %Q{<h1>First post</h1>
<p>Some dummy content with html <a href="http://google.com" target="_blank">link.</a></p>}}],
["2010-01-03-second-post.html", { yml_frontmatter: %Q{--- 
layout: post
title: Second Post
categories: events
rss: true
comments: true
tags:
- news
- events
- projects
---},
content: %Q{<h1>Second post</h1>
<p>This is another post with some <a href="http://google.com" target="_blank">link.</a></p>}}],
["2011-02-04-third-post.html", { yml_frontmatter: %Q{--- 
layout: post
title: Third Post
categories: projects
rss: true
comments: true
tags:
- news
---},
content: %Q{<h1>Third post</h1>
<p>This is the third post</p>}}]]

  def generate_posts(path)
    POSTS.each do |post|
      filename = "#{path}/#{post.first}"
      #puts "Creating new post: #{filename}"
      open(filename, 'w') do |file|
        post.last.values.each do |value|
          file.puts "#{value}\n\n"
        end
      end
    end
  end
  
  def delete_posts(path)
    Dir["#{path}/" + "*.html"].each do |file|
      #puts "Deleting: #{file}"
      File.delete(file)
    end 
  end
  
  def get_posts
    @posts = []
    Dir[File.join(Post.load_path, "*.html")].each_with_index do |file, i|
      @posts << { id: i,
                  date: File.basename(file).scan(/\d+-/).join("/").gsub!(/-/,""),
                  title: File.basename(file).split(/- */, 4).last.capitalize.gsub!(/\.html/, "").gsub!(/-/, " "), 
                  url: File.basename(file)}
    end
  end
  
  def new_post(name, date, content, categories, tags)
    @post = Post.new( :name => name, :date => date, :content => content, :url => Post.load_path, :categories => categories, :tags => tags )
  end
  
end