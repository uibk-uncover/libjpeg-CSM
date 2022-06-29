
use_win_path = false;
if use_win_path, ENDL = '\'; else, ENDL = '/'; end

%%%%%%%%%%%%%%%%
% EXTRACT JSRM %
%%%%%%%%%%%%%%%%

bpnzac = .4;


% extracts JSRM (cc-JRM + SRMQ1) from cover into mat file
for v_alice = {'6b' '7'}
    path = {[ 'data' ENDL sprintf('ALASKA_%s', char(v_alice)) ]};

    % Eve's libjpeg version independent on Alice
    for v_eve = {'6b' '7'}

        % paths
        dir_y0 = 'cover';
        dir_x0 = sprintf('%s_decompressed%s', dir_y0, char(v_eve));
        dir_y0cc = sprintf('%s_compressed%s', dir_y0, char(v_eve));
        % list files
        y0_names = {dir([char(path) ENDL dir_y0 ENDL '*.jpeg']).name}; % list y0
        x0_names = {dir([char(path) ENDL dir_x0 ENDL '*.png']).name}; % list x0
        y0cc_names = {dir([char(path) ENDL dir_y0cc ENDL '*.jpeg']).name}; % list y0cc
        % empty matrix for JSRM vectors
        C_jsrm = zeros(numel(y0_names), 22510 + 12753);

        % iterate files
        sprintf('Cover [a%s,e%s] %d',char(v_alice),char(v_eve),numel(y0_names))
        for idx = 1:numel(y0_names)
            idx
            % filenames
            y0_name = [char(path) ENDL dir_y0 ENDL char(y0_names(idx))];
            x0_name = [char(path) ENDL dir_x0 ENDL char(x0_names(idx))];
            y0cc_name = [char(path) ENDL dir_y0cc ENDL char(y0cc_names(idx))];
            % load files (DCT for jpeg, RGB for png)
            y0 = jpeg_read(y0_name); % y0
            x0 = double(imread(x0_name)); % x0
            %x0 = rgb2gray(x0); % grayscale
            x0 = x0(:,:,2); % green channel
            y0cc = jpeg_read(y0cc_name); % y0cc
            % extract JSRM
            f_ccJRM = ccJRM(y0, y0cc); % get cc-JRM(y0, y0cc)
            f_SRMQ1 = SRMQ1(x0); % get SRMQ1 (x0)
            C_jsrm(idx,:) = [struct2vec(f_ccJRM, 1) struct2vec(f_SRMQ1, 0)]; % concat
        end
        % save matrix to mat file
        save(sprintf('data/C_jsrm_%s_%s.mat',char(v_alice),char(v_eve)), 'C_jsrm', '-v7.3');
    end

end


% extracts JSRM (cc-JRM + SRMQ1) from stego into mat file
for v_alice = {'6b' '7'}
    path = {[ 'data' ENDL sprintf('ALASKA_%s', char(v_alice)) ]};

    % Eve's libjpeg version independent on Alice
    for v_eve = {'6b' '7'}
        
        % paths
        dir_ym = sprintf('stego_juniward_%.1f',bpnzac);
        dir_xm = sprintf('%s_decompressed%s',dir_ym,char(v_eve));
        dir_ymcc = sprintf('%s_compressed%s',dir_ym,char(v_eve));
        % list files
        ym_names = {dir([char(path) ENDL dir_ym ENDL '*.jpeg']).name}; % list ym
        xm_names = {dir([char(path) ENDL dir_xm ENDL '*.png']).name};  % list xm
        ymcc_names = {dir([char(path) ENDL dir_ymcc ENDL '*.jpeg']).name}; % list ymcc
        S_jsrm = zeros(numel(ym_names), 22510 + 12753);
            
        % iterate files
        sprintf('Stego [a%s,e%s] %.1f %d',char(v_alice),char(v_eve),bpnzac,numel(ym_names))
        for idx = 1:numel(ym_names)
            idx
            % filenames
            ym_name = [char(path) ENDL dir_ym ENDL char(ym_names(idx))];
            xm_name = [char(path) ENDL dir_xm ENDL char(xm_names(idx))];
            ymcc_name = [char(path) ENDL dir_ymcc ENDL char(ymcc_names(idx))];
            % load
            ym = jpeg_read(ym_name); % ym
            xm = double(imread(xm_name)); % x0
            %xm = rgb2gray(xm); % grayscale
            xm = xm(:,:,2); % green channel
            ymcc = jpeg_read(ymcc_name); % ymcc
            % extract JSRM
            f_ccJRM = ccJRM(ym, ymcc); % get cc-JRM(ym, ymcc)
            f_SRMQ1 = SRMQ1(xm); % get SRMQ1 (xm)
            S_jsrm(idx,:) = [struct2vec(f_ccJRM, 1) struct2vec(f_SRMQ1, 0)]; % concat
        end
        % save matrix to mat file
        save(sprintf('data/S_jsrm_%s_%s_%.1f.mat',char(v_alice),char(v_eve),bpnzac), 'S_jsrm', '-v7.3');
    end

end

