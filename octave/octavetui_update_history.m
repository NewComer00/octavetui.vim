function octavetui_update_history(operation)
    history_num = str2num(getenv('OCTAVETUI_HISTORY_NUM'));
    tempfile = getenv('OCTAVETUI_HISTORY');

    if strcmp(operation, 'write')
        history_list = history(history_num+1);
        fp = fopen(tempfile,'wt');
        fputs(fp,strjoin(history_list,"\n"));
        fclose(fp);
    elseif strcmp(operation, 'read')
        history('-r',tempfile);
        delete(tempfile);
    end
