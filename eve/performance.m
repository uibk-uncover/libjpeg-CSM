function [E,fp,md] = evaluate(predC, predS)
    fp = false_positive_rate(predC, predS);
    md = missed_detection_rate(predC, predS);
    E = (fp + md) / 2;
    %prec = precision(predC, predS);
    %rec = recall(predC, predS);
    %f1 = 2*prec*rec/(prec+rec);
end
%function [score] = misclassification(predC, predS)
%    [TP,TN,FP,FN] = confmat(predC.predictions, predS.predictions);
%    score = (FP + FN) / (TP + TN + FP + FN);
%end
function [score] = false_positive_rate(predC, predS)
    [TP,TN,FP,FN] = confmat(predC.predictions, predS.predictions);
    score = (FP) / (TP+FP);
end
function [score] = missed_detection_rate(predC, predS)
    [TP,TN,FP,FN] = confmat(predC.predictions, predS.predictions);
    score = (FN) / (TP+FN);
end
%function [score] = accuracy(predC, predS)
%    [TP,TN,FP,FN] = confmat(predC.predictions, predS.predictions);
%    score = (TP + TN) / (TP + TN + FP + FN);
%end
%function [score] = precision(predC, predS)
%    [TP,TN,FP,FN] = confmat(predC.predictions, predS.predictions);
%    score = (TP) / (TP + FP);
%end
%function [score] = recall(predC, predS)
%    [TP,TN,FP,FN] = confmat(predC.predictions, predS.predictions);
%    score = (TP) / (TP + FN);
%end

function [TP,TN,FP,FN] = confmat(predC, predS)
    TP = sum(predS ==  1); TN = sum(predC == -1);
    FN = sum(predS == -1); FP = sum(predC == 1);
end