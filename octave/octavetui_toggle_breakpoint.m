function octavetui_toggle_breakpoint(operation, filename, linenum_str)
    octavetui_hide_history();

    if strcmp(operation, 'set')
        dbstop(filename, linenum_str);
    elseif strcmp(operation, 'del')
        dbclear(filename, linenum_str);
    end

    octavetui_update_breakpoint();
end
