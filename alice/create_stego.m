
use_win_path = false;
if use_win_path, ENDL = '\'; else, ENDL = '/'; end

%%%%%%%%%%%%%
% EMBEDDING %
%%%%%%%%%%%%%

bpnzac = .4;

% embed J-UNIWARD
for v_alice = {'6b','7'}
    path = {[ 'data' ENDL sprintf('ALASKA_%s', char(v_alice)) ]};
    
    % list files 
    dir_y0 = 'cover';
    dir_x0 = sprintf('%s_decompressed%s', dir_y0, char(v_alice));
    dir_ym = sprintf('stego_juniward_%.1f', bpnzac);
    mkdir([char(path) ENDL dir_ym]);
    y0_names = {dir([char(path) ENDL dir_y0 ENDL '*.jpeg']).name};
    x0_names = {dir([char(path) ENDL dir_x0 ENDL '*.png']).name};

    % iterate files
    numel(y0_names)
    for idx = 1:numel(y0_names)
        idx
        y0_name = [char(path) ENDL dir_y0 ENDL char(y0_names(idx))];
        x0_name = [char(path) ENDL dir_x0 ENDL char(x0_names(idx))];
        % load
        y0 = jpeg_read(y0_name);      % y0
        x0 = double(imread(x0_name)); % x0
        % embed J-UNIWARD
        ym = J_UNIWARD(y0, x0, bpnzac); % embed into y0 -> ym
        ym_name = [char(path) ENDL dir_ym ENDL char(y0_names(idx))];
        jpeg_write(ym, ym_name);
    end

end
