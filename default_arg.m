function arg = default_arg( default, args, n )

if length(args) < n
   arg = default;
else
   arg = args{n};
end