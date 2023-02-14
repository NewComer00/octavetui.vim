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
            if ischar(_var)
                value_str = '';
                for c = 1:length(_var)
                    if isprint(_var(c))
                        value_str = [value_str, _var(c)];
                    else
                        hexcode = strcat('\x',...
                            dec2hex(unicode2native(_var(c),'UTF-8'),2)...
                            );
                        value_str = [value_str, hexcode];
                    end
                end
                value_str = strcat('"', value_str, '"');
            elseif isnumeric(_var) || islogical(_var)
                max_precision = str2num(getenv('OCTAVETUI_MAX_PRECISION'));
                value_str = mat2str(_var, max_precision);
            elseif class(_var) == 'function_handle'
                value_str = func2str(_var);
            end
        end
        var_valstrings = [var_valstrings;value_str];
    end
end
