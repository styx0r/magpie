module ModelsHelper

  def all_shell
    # Lists all shell files in the model subdirectory
    @shell_files, status = Open3.capture2("cd #{@model.path}; git ls-tree -r HEAD --name-only | grep '.sh$'")
    @shell_files.split
  end

end
