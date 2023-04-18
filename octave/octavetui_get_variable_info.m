function [var_descriptions, var_valstrings] = octavetui_get_variable_info(var_values)
    var_descriptions = '';
    var_valstrings = '';
    for i = 1:length(var_values)
        _var = var_values{i};

        % var description
        descriptors = {};
        if issparse(_var)
            descriptors{end+1} = 'sparse';
        end
        if iscomplex(_var)
            descriptors{end+1} = 'complex';
        end
        descriptors{end+1} = class(_var);
        descriptors{end+1} = regexprep(int2str(size(_var)),'\s*','x');

        var_descriptions = [var_descriptions;strjoin(descriptors,' ')];

        % var value
        value_str = '...';
        max_numel = getenv('OCTAVETUI_MAX_NUMEL');
        if numel(_var) <= max_numel && length(size(_var)) <= 2
            % if the variable is a unicode string
            % display the string in an unambiguous printable form
            if ischar(_var)
                unicode_index = unicode_idx(_var);
                value_str = '';
                % if _var is an empty string, the loop will not be executed
                for i = 1:max(unicode_index(:))
                    % get the current unicode char
                    cur_unicode_char = _var(unicode_index==i);
                    % convert special characters in strings back to their escaped forms
                    if cur_unicode_char == "\0"
                        unescaped_char = '\0';
                    else
                        unescaped_char = undo_string_escapes(cur_unicode_char);
                    end
                    % if the char is still unprintable, display it in octal
                    if length(unescaped_char) == 1 && ~isprint(unescaped_char)
                        octcode = strcat('\', dec2base(...
                            uint8(unescaped_char), 8, 3));
                        value_str = [value_str, octcode];
                    else
                        % if the escaped form of the char is printable, that's good!
                        value_str = [value_str, unescaped_char];
                    end
                end
                value_str = strcat('"', value_str, '"');
            elseif isnumeric(_var) || islogical(_var)
                max_precision = str2num(getenv('OCTAVETUI_MAX_PRECISION'));
                value_str = mat2str(_var, max_precision);
            elseif strcmp(class(_var), 'function_handle')
                value_str = func2str(_var);
            end
        end
        var_valstrings = [var_valstrings;value_str];
    end
end
