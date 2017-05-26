function check_esc
global chk ao
ks=cgkeymap;

                  if ks(1);
                      if chk
                       putsample(ao,[-5 -5])
                      end
                       pause(.5)
                       ks = 0;
                       cgtext('Esc = Beenden',0,100)
                       cgtext('Leertaste = Fortsetzen',0,0)
                       cgflip(0,0,0)

                       while sum(ks) == 0;
                       ks=cgkeymap;
                       end
           
                           if ks(1)
                               xt=1;
                               if chk
                               putsample(ao,[5 5])
                               putsample(ao,[0 0])
                               end
                               cgshut
                           else
                               if chk
                               putsample(ao,[0 0])
                               end
                           end
                  end