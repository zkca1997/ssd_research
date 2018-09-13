function [feat_matrix, labels] = ParseFileHeirarchy( parent_dir, FilterSignal, CreateFeatures )

  feat_matrix = zeros(0, 300);
  labels      = [];

  % iterate through each device subdirectory
  type_list = dir(parent_dir);
  for type_dir = type_list'
    % iterate through each device type subdirectory
    if type_dir.isdir && type_dir.name(1) ~= '.'
      % iterate through each individual device of that type
      device_list = dir(AbsPath(type_dir));
      for device_dir = device_list'
        % iterate through each firmware subdirectory
        if device_dir.isdir && device_dir.name(1) ~= '.'
          firm_list = dir(AbsPath(device_dir));
          for firm_dir = firm_list'
            % iterate through each collection batch
            if firm_dir.isdir && firm_dir.name(1) ~= '.'
              batch_list = dir(AbsPath(firm_dir));
              for batch_dir = batch_list'
                % apply the appropriate labelling function
                if batch_dir.isdir && batch_dir.name(1) ~= '.'
                  fprintf('Parsing Batch %s of Firmware %s for Device %s\n',...
                    batch_dir.name, firm_dir.name, device_dir.name);
                  [feats, label] = ReadBatch( batch_dir );
                  labels = [labels; label];
                  feat_matrix = [feat_matrix; feats];
                end
              end
            end
          end
        end
      end
    end
  end

end
