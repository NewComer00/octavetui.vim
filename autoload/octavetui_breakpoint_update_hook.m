function octavetui_breakpoint_update_hook(preserve_history)
    if preserve_history
        octavetui_history_hook('write');
    end

    tempfile = getenv('OCTAVETUI_BREAKPOINT');

    fp = fopen(tempfile, 'wt');
    brkpnt_list = dbstatus();
    template = strcat("%s\t%s\t%d\t%s\t", newline);
    for i = 1:length(brkpnt_list)
        bp = brkpnt_list(i);
        fprintf(fp, template,...
            bp.name,bp.file,bp.line,bp.cond);
    end
    fp = fclose(fp);

    if preserve_history
        octavetui_history_hook('read');
    end
end
