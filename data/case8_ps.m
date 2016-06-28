function ps = case8_ps

ps.baseMVA = 100.000000;

ps.bus = [...
%ID type Pd Qd Gs Bs area Vmag Vang basekV Vmax Vmin lam P lam Q mu Vx mu Vn locX locY 
 1 3 0 0 0 0 1 1.05 0 230 1 1.05 1.05 0 0 0 0 1 2;
 2 2 0 0 0 0 1 1.05 -3.67116 230 1 1.05 1.05 0 0 0 0 2 2;
 3 2 0 0 0 0 1 1.07 -4.27327 230 1 1.07 1.07 0 0 0 0 3 2;
 4 1 0 0 0 0 1 0.989373 -4.19582 230 1 1.05 0.95 0 0 0 0 1 1;
 5 1 0 0 0 0 1 0.985445 -5.27639 230 1 1.05 0.95 0 0 0 0 2 1;
 6 1 0 0 0 0 1 1.00443 -5.94745 230 1 1.05 0.95 0 0 0 0 3 1;
 7 1 0 0 0 0 1 1.00443 -5.94745 230 1 1.05 0.95 0 0 0 0 3 1;
 8 1 0 0 0 0 1 1.00443 -5.94745 230 1 1.05 0.95 0 0 0 0 3 1;
];

ps.branch = [...
%from to R X B rateA rateB rateC tap shift status 
 1 2 0.1 0.2 0.04 40 40 40 1 0 1 28.6897 -15.4187 -27.7847 12.8185 0 0 0.310195 0.29142 0 0 0;
 1 4 0.05 0.2 0.04 60 60 60 1 0 1 43.5849 20.1201 -42.4974 -19.9326 0 0 0.457189 0.474439 0 0 0;
 1 5 0.08 0.3 0.06 40 40 40 1 0 1 35.6009 11.2547 -34.5273 -13.4497 0 0 0.355595 0.376017 0 0 0;
 2 3 0.05 0.25 0.06 40 40 40 1 0 1 2.93032 -12.2687 -2.89001 5.72812 0 0 0.120132 0.0599614 0 0 0;
 2 4 0.05 0.1 0.02 60 60 60 1 0 1 33.0909 46.0541 -31.5858 -45.1252 0 0 0.540092 0.55673 0 0 0;
 2 5 0.1 0.3 0.04 30 30 30 1 0 1 15.5145 15.3532 -15.0166 -18.0065 0 0 0.207877 0.237927 0 0 0;
 2 6 0.07 0.2 0.05 90 90 90 1 0 1 26.2489 12.3995 -25.6656 -16.0113 0 0 0.276478 0.301171 0 0 0;
 3 5 0.12 0.26 0.05 70 70 70 1 0 1 19.1168 23.1745 -18.0232 -26.095 0 0 0.280764 0.321826 0 0 0;
 3 6 0.02 0.1 0.02 80 80 80 1 0 1 43.7732 60.7242 -42.7698 -57.861 0 0 0.699595 0.716355 0 0 0;
 4 5 0.2 0.4 0.08 20 20 20 1 0 1 4.08324 -4.94213 -4.04702 -2.78527 0 0 0.0647959 0.0498541 0 0 0;
 5 6 0.1 0.3 0.06 40 40 40 1 0 1 1.61416 -9.66345 -1.56456 3.87235 0 0 0.0994205 0.0415807 0 0 0;
 1 7 0.1 0.3 0.06 40 40 40 1 0 1 1.61416 -9.66345 -1.56456 3.87235 0 0 0.0994205 0.0415807 0 0 0;
 7 8 0.1 0.3 0.06 40 40 40 1 0 1 1.61416 -9.66345 -1.56456 3.87235 0 0 0.0994205 0.0415807 0 0 0;
];

ps.gen = [...
%bus Pg Qg Qmax Qmin Vsp mBase status Pmax Pmin mu_Px mu_Pn mu_Qx mu_Qn type cost 
 1 107.875 15.9562 100 -100 1.05 100 1 150 0 0 0 0 0 3 30 1;
 2 50 74.3565 100 -100 1.05 100 1 150 0 0 0 0 0 2 40 0;
 3 60 89.6268 60 -100 1.07 100 1 150 0 0 0 0 0 2 50 0;
];

ps.shunt = [...
%bus P Q frac_S frac_Z status type value 
 4 70 70 1 0 1 1 1000 0;
 5 70 70 1 0 1 1 1000 0;
 6 70 70 1 0 1 1 1000 0;
];

