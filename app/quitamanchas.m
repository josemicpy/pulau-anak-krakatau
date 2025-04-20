function z = quitamanchas(x, u, h, v)

  [F, C] = size(x);
  x = double(x);

  if v == 1
    z = zeros(F, C);
  else
    z = ones(F, C);
  end
  
  if h == 0
    for f = 1:F
      t = 0;
      for c = 1:C
        if x(f, c) == v
          t = t + 1;
        else
          if t > u
            z(f, c-t:c) = v;
          end
          t = 0;
        end      
      end
      if t > u
        z(f, C-t+1:C) = v;
      end
      f;
    end
  else
    for c = 1:C
      t = 0;
      for f = 1:F
        if x(f, c) == v
          t = t + 1;
        else
          if t > u
            z(f-t:f, c) = v;
          end
          t = 0;
        end      
      end
      if t > u
        z(F-t+1:F, c) = v;
      end
      f;
    end
  end

  z = double(z);

end
