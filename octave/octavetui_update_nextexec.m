function octavetui_update_nextexec()
    tempfile = getenv('OCTAVETUI_NEXTEXEC');

    [fp, msg] = fopen(tempfile, 'wt');
    if fp == -1
        error(msg);
    else
        try
            frame_depth = 3;
            nextexec = '';
            if isdebugmode()
                [stack,_] = dbstack();
                current_stack = stack(frame_depth);
                nextexec = strcat(int2str(current_stack.line), ...
                    "\t", current_stack.file);
            end
            fputs(fp, nextexec);
        catch
            fclose(fp);
            rethrow(lasterror);
        end
        fclose(fp);
    end
end
