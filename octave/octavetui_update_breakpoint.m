function octavetui_update_breakpoint()
    tempfile = getenv('OCTAVETUI_BREAKPOINT');

    [fp, msg] = fopen(tempfile, 'wt');
    if fp == -1
        error(msg);
    else
        try
            brkpnt_list = dbstatus();
            template = strcat("%s\t%s\t%d\t%s\t", "\n");
            for i = 1:length(brkpnt_list)
                bp = brkpnt_list(i);
                fprintf(fp, template,...
                    bp.name,bp.file,bp.line,bp.cond);
            end
        catch
            fclose(fp);
            rethrow(lasterror);
        end
        fclose(fp);
    end
end
