require File.dirname(__FILE__) + '/../lib/file_chisel'

describe FileChisel do
  it "should display version" do
    FileChisel::VERSION.should =~ /\d\.\d\.\d/
  end
end

