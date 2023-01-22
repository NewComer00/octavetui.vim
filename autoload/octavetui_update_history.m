function octavetui_update_history(operation)
    history_num = str2num(getenv('OCTAVETUI_HISTORY_NUM'));
    tempfile = getenv('OCTAVETUI_HISTORY');

    if strcmp(operation, 'write')
        history('-w',tempfile);
        str = fileread(tempfile);
        fp = fopen(tempfile,'wt');
        fputs(fp,strjoin(strsplit(str,newline)(max(1,end-1-history_num):end-1),newline));
        fclose(fp);
    elseif strcmp(operation, 'read')
        history('-r',tempfile);
    end
