function octavetui_update_nextexec()
    tempfile = getenv('OCTAVETUI_NEXTEXEC');

    fp = fopen(tempfile, 'wt');

    octave_version_str = version();
    octave_major_version = str2num(octave_version_str(1));
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

