require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Posts" do
  let(:user)  { Factory(:user) }
  
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
    end
  end
  
end
