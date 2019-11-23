function field = getfields( text )

field = {};
a = isspace( text );

n = length(a);
pos = 1;
i = 1;

while pos <= n
   
   while pos <= n & a(pos)
      pos=pos+1;
   end
   
   if pos > n; break; end;
   
   str = [];
   if text(pos) == ''''
      str = '''';
      pos = pos+1;
      while pos <= n & text(pos) ~= ''''
         str = [ str text(pos) ];
         pos = pos + 1;
      end
      pos = pos + 1;
      str = [ str '''' ];
   else
      while pos <= n  &  ~a(pos)
         str = [ str text(pos) ];
         pos = pos + 1;
      end
   end
   
   if ~isempty(str)
      field{i} = str;
   end
   
   i = i + 1;
   
end
