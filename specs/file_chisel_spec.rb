require File.dirname(__FILE__) + '/../lib/file_chisel'

describe FileChisel do
  describe "basics" do
    it "should display version" do
      FileChisel::VERSION.should =~ /\d\.\d\.\d/
    end

  end

end

