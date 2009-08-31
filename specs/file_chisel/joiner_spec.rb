require File.dirname(__FILE__) + '/../../lib/file_chisel'

describe FileChisel::Joiner do
  before do
    @filename = "newfile"
    @info = {1=>"firstpart", 2=>"secondpart"}
    @joiner = FileChisel::Joiner.new(@filename, @info)
  end

  describe "part" do
    before do
      @joiner.instance_variable_set("@part_filename", "abcdefgl")
      @expected_path = "#{@joiner.part_directory}#{@joiner.send(:hashed_directory_for_part)}/abcdefgl"
    end

    it "should generate hased directory" do
      expected = 'a/b/c/d/e/'
      @joiner.send(:hashed_directory_for_part).should == expected
    end

    it "should give full path to file" do
      @joiner.send(:path_to_part_file).should == @expected_path
    end

    it "should read part file" do
      filemock = mock(File)
      File.should_receive(:new).with(@expected_path, "r").and_return(filemock)
      filemock.should_receive(:read).and_return("content")
      filemock.should_receive(:close)
      @joiner.send(:read_part_file).should == "content"
    end
  end
end

