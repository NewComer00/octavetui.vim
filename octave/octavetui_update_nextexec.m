function octavetui_update_nextexec()
    tempfile = getenv('OCTAVETUI_NEXTEXEC');

    fp = fopen(tempfile, 'wt');
    nextexec = '';
    if isdebugmode()
        [stack,_] = dbstack(3);
        current_stack = stack(1);
        nextexec = strcat(int2str(current_stack.line), ...
            "\t", current_stack.file);
    end
    fputs(fp, nextexec);
    fclose(fp);
end

