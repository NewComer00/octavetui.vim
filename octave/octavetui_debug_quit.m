function octavetui_debug_quit(flag)
    octavetui_hide_history();

    if isdebugmode()
        octave_version_str = version();
        octave_major_version = str2num(octave_version_str(1));
        % 'dbquit all' does not exist on old versions
        if octave_major_version <= 5
            dbquit();
        else
            if strcmp(flag, 'all')
                dbquit('all');
            elseif strcmp(flag, 'stacked')
                dbquit();
            end
        end
    end

end
