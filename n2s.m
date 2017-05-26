function s = n2s(n)

s=num2str(n,3+round(log10(ceil(abs(n)))));
