require File.dirname(__FILE__) + '/../../lib/file_chisel'

describe FileChisel::Splitter do
  before do
    @fixture_file = File.new(File.dirname(__FILE__) + '/../fixtures/testfile', 'w')
    # making it a 1megabyte
    @fixture_file.truncate(2**20)
    @splitter = FileChisel::Splitter.new(@fixture_file.path)
  end

  it "should have default part directory" do
    @splitter.part_directory.should == FileChisel::DEFAULT_PART_DIR
  end 

  it "should be able to overwrite default part directory" do
    expected = 'tmp/parts/'
    @splitter.part_directory = expected
    @splitter.part_directory.should == expected
  end

  it "should make sure part directory ends with /" do
    expected = 'tmp/parts/'
    @splitter.part_directory = expected[0..-2] # 'tmp/parts'
    @splitter.part_directory.should == expected
  end

  it "should store file" do
    @splitter.instance_variable_get("@file").is_a?(File).should be_true
  end

  it "should store original filename" do
    expected = File.basename(@fixture_file.path)
    @splitter.instance_variable_get("@original_filename").should == expected
  end

  it "should take file size" do
    expected = 2**20
    @splitter.instance_variable_get("@file_size").should == expected
  end

  it "should generate info for file" do
    expected_part_map = { 1 => "fooo", 2 => "suoo" }
    @splitter.instance_variable_set("@part_map", expected_part_map)
    @splitter.instance_variable_set("@counter", "100")
    expected_block_size = @splitter.instance_variable_get("@block_size")
    expected = { :count => "100",
                 :block_size => expected_block_size,
                 :last_file_size => (2 ** 20) % expected_block_size,
                 :parts_map => expected_part_map }
    @splitter.send(:info_for_file).should == expected 
  end

  it "should generate manifest file" do
    filemock = mock(File)
    expected_filename = "#{@fixture_file.path}.manifest.yml"
    File.should_receive(:new).with(expected_filename, "w").and_return(filemock)
    filemock.should_receive(:print).with(an_instance_of(String))
    filemock.should_receive(:close)
    @splitter.send(:create_info_file!)
  end

  it "should split the file" do
    expected_block_size = @splitter.instance_variable_get("@block_size")
    expected_count = @fixture_file.stat.size / expected_block_size
    IO.should_receive(:read).
        with(@fixture_file.path, expected_block_size, instance_of(Fixnum)).
          exactly(expected_count).times.
            and_return("content")
    @splitter.should_receive(:create_fraction_file!).exactly(expected_count).times
    @splitter.should_receive(:create_info_file!).once
    @splitter.split
  end

  describe "part_file" do

    before do
      @splitter.instance_variable_set("@part_filename", "abcdef123455")
    end

    it "should make directory for parts" do
      expected = "#{@splitter.part_directory}a/b/c/d/e/"
      FileUtils.should_receive(:mkdir_p).with(expected)
      @splitter.send(:make_part_directory!)
    end

    it "should hash directories for parts" do
      @splitter.send(:hashed_directory_for_part).should == "a/b/c/d/e/"
    end

    it "should have file path for parts" do
      expected = "#{@splitter.part_directory}a/b/c/d/e/abcdef123455"
      @splitter.send(:path_to_part_file).should == expected
    end

    it "should create part file with part content" do
      expected_content = "part content"
      expected_path = @splitter.send(:path_to_part_file)
      filemock = mock(File)
      filemock.should_receive(:print).with(expected_content)
      filemock.should_receive(:close)
      @splitter.should_receive(:make_part_directory!)
      File.should_receive(:new).
          with(expected_path, "w").
            and_return(filemock)
      @splitter.send(:create_fraction_file!, expected_content)
    end

  end

  after do
    File.delete(@fixture_file.path)
  end

end

