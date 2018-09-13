function abs_path = AbsPath(dir_struct)
  abs_path = fullfile(dir_struct.folder, dir_struct.name);
end
