clc;clear all;close all;

cfg.m1=1;
cfg.m2=1;
cfg.Izz=1;
cfg.L=1;
cfg.b=1;

pert = 1;

Juan = RobotInit(pert);

cfg.Mx = [(2*cfg.m2*cfg.L^2)+2*cfg.Izz+cfg.m1*cfg.L^2 (cfg.m2*cfg.L^2)+cfg.Izz;
          (cfg.m2*cfg.L^2)+cfg.Izz (cfg.m2*cfg.L^2)+cfg.Izz]
      
cfg.Mxinv = inv(cfg.Mx)      
      
cfg.F = [-cfg.b 0;
         0 -cfg.b]

cfg.J = [cfg.L cfg.L; %Falta multiplicar por [s2 c2; y sumar [0 L;
         0     cfg.L]                        %0  0]           0 0]
     
cfg.V= [0 -cfg.L*cfg.m2;  %Falta multiplicarlo por s2, se hace en modelo
        cfg.L*cfg.m2 0]
      
cfg.Kv = [150 0; 0 150]
cfg.Kp = [250 0; 0 250]