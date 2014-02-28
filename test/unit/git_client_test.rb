require 'hieracrypta'
require 'test/unit'

class GitClientTest < Test::Unit::TestCase

  def initialize (args)
    super (args)
    git_repo_location = File.expand_path("../../..", __FILE__)
    @git = Hieracrypta::GitClient.new(git_repo_location)
  end
  
  def test_read_existing_file_from_existing_branch
#    @git.get_branch('realbranch', 'realfile')
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
#    @git.get_tag('realtag', 'apple')
  end
  
  def test_read_nonexisting_file_from_existing_tag
#    @git.get_tag('realtag', 'fakefile')
  end
  
  def test_read_existing_file_from_nonexisting_tag
#    @git.get_tag('faketag', 'apple')
  end
  
  def test_read_nonexisting_file_from_nonexisting_tag
#    @git.get_tag('faketag', 'fakefile')
  end
  
end
