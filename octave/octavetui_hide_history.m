function octavetui_hide_history()
    history_num = str2num(getenv('OCTAVETUI_HISTORY_NUM'));
    tempfile = getenv('OCTAVETUI_HISTORY');

    history_list = history(history_num+1);
    fp = fopen(tempfile,'wt');
    fputs(fp,strjoin(history_list,"\n"));
    fclose(fp);

    history('-r',tempfile);
    delete(tempfile);
end
