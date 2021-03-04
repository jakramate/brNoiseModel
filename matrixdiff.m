function [d] = matrixdiff(m1, m2)

d = sum(sum(abs(m1-m2)));