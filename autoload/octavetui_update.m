__octavetui_history_num__ = str2num(getenv('OCTAVETUI_HISTORY_NUM'));
__octavetui_history__ = getenv('OCTAVETUI_HISTORY');

history('-w',__octavetui_history__);
__octavetui_str__=fileread(__octavetui_history__);
__octavetui_fp__=fopen(__octavetui_history__,'wt');
fputs(__octavetui_fp__,strjoin(strsplit(__octavetui_str__,newline)(max(1,end-1-__octavetui_history_num__):end-1),newline));
fclose(__octavetui_fp__);
clear __octavetui_history__ __octavetui_fp__ __octavetui_str__ __octavetui_history_num__;

%%

__octavetui_variable__ = getenv('OCTAVETUI_VARIABLE');

__octavetui_fp__=fopen(__octavetui_variable__,'wt');
fputs(__octavetui_fp__,evalc('whos -regexp (?!^__octavetui_.*__$)(^.*$)'));
__octavetui_fp__=fclose(__octavetui_fp__);
clear __octavetui_variable__ __octavetui_fp__;

%%

__octavetui_history__ = getenv('OCTAVETUI_HISTORY');

history('-r',__octavetui_history__);
clear __octavetui_history__;
