function resultado = reducibleHomogenea(M, N)
  syms x y;

  sustx = solve(subs(M, {'x', 'y'}, {x, y}) == 0, x);

  valy = solve(subs(N, {'x', 'y'}, {sustx, y}) == 0, y);

  valx = solve(subs(M, {'x', 'y'}, {x, valy}) == 0, x);

  M_trans(x, y) = subs(M, {'x', 'y'}, {x+valx, y+valy});
  N_trans(x, y) = subs(N, {'x', 'y'}, {x+valx, y+valy});

  expr = homogenea(M_trans, N_trans);
  resultado = subs(expr, {'x', 'y'}, {x-valx, y-valy});
endfunction
