function clear_ao
global ao
delete(ao)
x=timerfindall;
delete(x);
clear x ao;
end