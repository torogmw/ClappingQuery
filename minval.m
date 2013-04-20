function x = minval(a,b,c)
    if a<=b && a<=c
        x = a;
    end
    if b<=a && b<=c
        x = b;
    end
    if c<=a && c<=b
        x = c;
    end
    return;
end