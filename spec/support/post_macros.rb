module PostMacros
  
  def find_posts
    @posts = []
    Dir[File.join(Post.load_path, "*.html")].each_with_index do |file, i|
      @posts << { id: i,
                  date: File.basename(file).scan(/\d+-/).join("/").gsub!(/-/,""),
                  title: File.basename(file).split(/- */, 4).last.capitalize.gsub!(/\.html/, "").gsub!(/-/, " "), 
                  url: File.basename(file)}
    end
  end
  
end