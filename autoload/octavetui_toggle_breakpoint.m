function octavetui_toggle_breakpoint(operation, filename, linenum_str)
    octavetui_update_history('write');

    if strcmp(operation, 'set')
        dbstop(filename, linenum_str);
    elseif strcmp(operation, 'unset')
        dbclear(filename, linenum_str);
    end

    octavetui_update_breakpoint();

    octavetui_update_history('read');
end
