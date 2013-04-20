function dist = dtw(p, q, p_un, q_un)
   
    plen = 0;
    qlen = 0;
    for i=1:length(p)
        if p(i)>0
            plen = plen+1;
        end
    end
    for i=1:length(q)
        if q(i)>0
            qlen = qlen+1;
        end
    end
    inf = 1000000;
    mGamma = zeros(plen+1, qlen+1);
    for i=2:plen+1
        mGamma(i,1)=inf;
    end
    for i=2:qlen+1
        mGamma(1,i)=inf;
    end
    for i=2:plen
        for j=2:qlen
            if nargin==4
                cost = max(p_un(i),q_un(j))*abs(p(i) - q(j));
            end
            if nargin==2
                cost = sqrt(abs(p(i) - q(j))*abs(p(i) - q(j)));
            end
            mGamma(i,j) = cost + minval(mGamma(i-1,j), mGamma(i,j-1), mGamma(i-1,j-1));
        end
    end
    dist=mGamma(plen,qlen);
    return;
end

