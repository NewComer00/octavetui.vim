function octavetui_breakpoint_hook(operation, filename, linenum_str)
    octavetui_history_hook('write');

    if strcmp(operation, 'set')
        dbstop(filename, linenum_str);
    else
        dbclear(filename, linenum_str);
    end

    octavetui_breakpoint_update_hook(false);

    octavetui_history_hook('read');
end
