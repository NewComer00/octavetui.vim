__octavetui_variable__ = getenv('OCTAVETUI_VARIABLE');
__octavetui_fp__ = fopen(__octavetui_variable__, 'wt');

__octavetui_who__ = who("-regexp","(?!^__octavetui_.*__$)(^.*$)");
__octavetui_var_values__ = cell(length(__octavetui_who__),1);
__octavetui_var_names__ = '';
__octavetui_var_number__ = 0;
for __octavetui_tmp__ = 1:length(__octavetui_who__)
    if isvarname(__octavetui_who__{__octavetui_tmp__})
        __octavetui_var_names__ = [__octavetui_var_names__; __octavetui_who__{__octavetui_tmp__}];
        __octavetui_var_number__ = __octavetui_var_number__ + 1;
        % TODO: for convenience of coding, make a copy of the given variable
        % copy by value, copy by reference, or copy on modify?
        % it depends on the Octave implementation
        __octavetui_var_values__{__octavetui_var_number__} = eval(__octavetui_var_names__(__octavetui_var_number__,:));
    end
end

[__octavetui_var_descriptions__, __octavetui_var_valstrings__] = ...
    octavetui_get_variable_info(__octavetui_var_values__);

for __octavetui_tmp__ = 1:__octavetui_var_number__
    fprintf(__octavetui_fp__, strcat("%s\t%s\t%s", "\n"),...
        __octavetui_var_names__(__octavetui_tmp__,:),...
        __octavetui_var_descriptions__(__octavetui_tmp__,:),...
        __octavetui_var_valstrings__(__octavetui_tmp__,:));
end

__octavetui_tmp__ = fclose(__octavetui_fp__);
clear __octavetui_*__;
