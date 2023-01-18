function octavetui_breakpoint_hook(filename, linenum_str)
    octavetui_history_hook('write');

    tempfile = getenv('OCTAVETUI_BREAKPOINT');

    actual_linenum = dbstop(filename, linenum_str);
    fp = fopen(tempfile, 'wt');
    fputs(fp, int2str(actual_linenum));
    fp = fclose(fp);

    octavetui_history_hook('read');
end
