package util;

  function automatic bit[15:0] roundToInt16(
    input real fl
  );

    real floored;
    real frac;
    bit[15:0] res;

    floored = $floor(fl);
    frac = fl - floored;

    if (frac < 0.5) begin
      res = int'(floored); 
    end
    else if (frac > 0.5) begin
      res = int'(floored + 1.0);
    end
    else begin
      if (int'(floored) % 2 == 0) begin
        res = int'(floored);
      end
      else begin
        res = int'(floored + 1.0);
      end
    end

    return res;
  endfunction

endpackage