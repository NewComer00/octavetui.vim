function octavetui_get_lasterror()
    octavetui_hide_history();

    tempfile = getenv('OCTAVETUI_LASTERR');
    [fp, msg] = fopen(tempfile, 'wt');
    if fp == -1
        error(msg);
    else
        try
            frame_depth = 1;
            last_error = '';
            errors = lasterror();
            stacks = errors.stack;
            if length(stacks) >= frame_depth
                current_stack = stacks(frame_depth);
                last_error = strcat(int2str(current_stack.line), ...
                    "\t", int2str(current_stack.column), ...
                    "\t", current_stack.file);
            end
            fputs(fp, last_error);
        catch
            fclose(fp);
            rethrow(lasterror);
        end
        fclose(fp);
    end
end
