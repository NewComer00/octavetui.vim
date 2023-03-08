function octavetui_update_nextexec()
    tempfile = getenv('OCTAVETUI_NEXTEXEC');

    fp = fopen(tempfile, 'wt');

    frame_depth = 3;
    nextexec = '';
    if isdebugmode()
        [stack,_] = dbstack();
        current_stack = stack(frame_depth);
        nextexec = strcat(int2str(current_stack.line), ...
            "\t", current_stack.file);
    end
    fputs(fp, nextexec);
    fclose(fp);
end
