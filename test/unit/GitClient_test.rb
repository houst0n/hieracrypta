require 'hieracrypta'
require 'test/unit'

class GitClientTest < Test::Unit::TestCase

  def initialize (args)
    super (args)
    git_repo_location = File.expand_path("../../..", __FILE__)
    @git = Hieracrypta::GitClient.new(git_repo_location)
  end
  
  def test_read_existing_file_from_existing_branch
    content = @git.get_branch('testbranch', 'test/unit/testdata/testfile2')
    assert_equal "This is a test file on the branch testbranch\n", content
  end
  
  def test_read_nonexisting_file_from_existing_branch
    assert_raise Hieracrypta::NoSuchFile do
       @git.get_branch('testbranch', 'test/unit/testdata/fakefile2')
    end
  end
  
  def test_read_existing_file_from_nonexisting_branch
    assert_raise Hieracrypta::NoSuchBranch do
       @git.get_branch('fakebranch', 'test/unit/testdata/testfile2')
    end
  end
  
  def test_read_nonexisting_file_from_nonexisting_branch
    assert_raise Hieracrypta::NoSuchBranch do
      @git.get_branch('fakebranch', 'test/unit/testdata/fakefile2')
    end
  end
  
  def test_read_existing_file_from_existing_tag
    content = @git.get_tag('testtag', 'test/unit/testdata/testfile')
    assert_equal "This is a test file on the tag testtag\n", content
  end
  
  def test_read_nonexisting_file_from_existing_tag
    assert_raise Hieracrypta::NoSuchFile do
      @git.get_tag('testtag', 'test/unit/testdata/fakefile')
    end
  end
  
  def test_read_existing_file_from_nonexisting_tag
    assert_raise Hieracrypta::NoSuchTag do
      @git.get_tag('faketag', 'test/unit/testdata/testfile')
    end
  end
  
  def test_read_nonexisting_file_from_nonexisting_tag
    assert_raise Hieracrypta::NoSuchTag do
      @git.get_tag('faketag', 'test/unit/testdata/fakefile')
    end
  end
  
end
