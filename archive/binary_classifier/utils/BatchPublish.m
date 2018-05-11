function BatchPublish(in_dir, out_dir, format)
% publish all .m files in a given directory

  filelist = dir(in_dir);    % fetch all the files in the folder
  lastfile = length(filelist);  % last file in list

  options = struct('format', format, 'outputDir', out_dir, 'evalCode', false);

  for i = 1:lastfile
    if contains(filelist(i).name, '.m')
      file = [in_dir, filelist(i).name];
      publish(file, options);
    end
  end

end
