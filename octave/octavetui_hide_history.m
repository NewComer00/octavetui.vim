function octavetui_hide_history()
    history_num = str2num(getenv('OCTAVETUI_HISTORY_NUM'));
    tempfile = getenv('OCTAVETUI_HISTORY');

    history_list = history(history_num+1);
    [fp, msg] = fopen(tempfile, 'wt');
    if fp == -1
        error(msg);
    else
        try
            fputs(fp,strjoin(history_list,"\n"));
        catch
            fclose(fp);
            rethrow(lasterror);
        end
        fclose(fp);
        history('-r',tempfile);
        delete(tempfile);
    end
end
