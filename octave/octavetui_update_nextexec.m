function octavetui_update_nextexec()
    tempfile = getenv('OCTAVETUI_NEXTEXEC');

    fp = fopen(tempfile, 'wt');

    octave_version = version();
    octave_major_version = str2num(octave_version(1));
    if octave_major_version <= 5
        frame_depth = 3;
    else
        frame_depth = 4;
    end

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

