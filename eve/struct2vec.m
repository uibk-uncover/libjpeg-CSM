function vec = struct2vec(f, col)
    vec = [];
    L = fieldnames(f);
    for i = 1:length(L)
        if col
            vec = [vec eval([ 'f.' char(L(i)) ])'];
        else
            vec = [vec eval([ 'f.' char(L(i)) ])];
        end
    end
end