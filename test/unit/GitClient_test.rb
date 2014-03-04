require 'hieracrypta'
require 'test/unit'

class GitClientTest < Test::Unit::TestCase

  def initialize (args)
    super (args)
    git_repo_location = File.expand_path("../../..", __FILE__)
    @git = Hieracrypta::GitClient.new(git_repo_location)
  end
  
  def test_read_existing_file_from_existing_branch
#    content=@git.get_branch('realbranch', 'realfile')
  end
  
  def test_read_nonexisting_file_from_existing_branch
#    @git.get_branch('realbranch', 'fakefile')
  end
  
  def test_read_existing_file_from_nonexisting_branch
#    @git.get_branch('fakebranch', 'apple')
  end
  
  def test_read_nonexisting_file_from_nonexisting_branch
#    @git.get_branch('fakebranch', 'fakefile')
  end
  
  def test_read_existing_file_from_existing_tag
    content = @git.get_tag('testtag', 'test/unit/testdata/testfile')
    assert_equal "This is a test file on the tag testtag\n", content
  end
  
  def test_read_nonexisting_file_from_existing_tag
    content = @git.get_tag('testtag', 'test/unit/testdata/fakefile')
    assert_equal nil, content
  end
  
  def test_read_existing_file_from_nonexisting_tag
    content = @git.get_tag('faketag', 'test/unit/testdata/testfile')
    assert_equal nil, content
  end
  
  def test_read_nonexisting_file_from_nonexisting_tag
    content = @git.get_tag('faketag', 'test/unit/testdata/fakefile')
    assert_equal nil, content
  end
  
end
