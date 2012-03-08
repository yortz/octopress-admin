require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "AuthenticationSpec" do
  let(:user)  { Factory(:user) }
  
  it "should authenticate with matching username & password" do
    login(user.email, user.password)
    current_path.should eq(root_path)
    page.should have_content("Logged in!")
  end
  
  it "should not authenticate with wrong username & password" do
    login("user@email.com", "somesecretpwd")
    current_path.should eq(sessions_path)
    page.should have_content("Email or password is invalid")
  end
  
  it "should logout authenticated user" do
    login(user.email, user.password)
    click_link "Log Out"
    current_path.should eq(login_path)
    page.should have_content("Logged out!")
  end
  
end
