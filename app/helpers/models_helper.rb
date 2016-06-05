module ModelsHelper

  def all_shell
    # Lists all shell files in the model subdirectory
    files = Dir.entries(@model.path)
    shell_files = files.select do |file|
      file.end_with?('.sh')
    end
  end
end
