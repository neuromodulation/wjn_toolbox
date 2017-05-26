function [k] = fibonacci(n)
%Returns a Fibonacci sequence of n terms starting at k(1) = 1 & k(2) = 1 in
%a column matrix
k = zeros(n,1);
k(1) = 1;
k(2) = 1;
for i = 3:n
    k(i) = k(i-1) + k(i-2);
end