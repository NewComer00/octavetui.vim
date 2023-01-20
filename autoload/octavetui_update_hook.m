octavetui_history_hook('write');

__octavetui_variable__ = getenv('OCTAVETUI_VARIABLE');

__octavetui_fp__ = fopen(__octavetui_variable__, 'wt');
__octavetui_tmp__ = fputs(__octavetui_fp__, evalc('whos -regexp (?!^__octavetui_.*__$)(^.*$)'));
__octavetui_tmp__ = fclose(__octavetui_fp__);
clear __octavetui_variable__ __octavetui_fp__ __octavetui_tmp__;

octavetui_breakpoint_update_hook(false);

octavetui_history_hook('read');
