function arm = RobotInit(pert)
    N = 2; % cantidad de links

    % Largos 1m
    L1 = 1;
    L2 = 1;
    L3 = 1;
    % Masa 1kg
    m1 = 1;
    m2 = 1;
    m3 = 1;
    % Centro de masa en extremo
    r=1;

    % Friccion unitaria:     'B', 1
    b = 1;  


    g=9.81;

    DH = struct('d', cell(1,N), 'a', cell(1,N), 'alpha', cell(1,N), 'theta', cell(1,N),...
        'type', cell(1,N)); %genera estructura base
    DH(1).alpha = 0;    DH(1).a = 0;    DH(1).d = 0;    DH(1).type = 'R';
    DH(2).alpha = 0;    DH(2).a = L1;   DH(2).d = 0;    DH(2).type = 'R';

    for  iLink = 1:N
            links{iLink} = Link('d', DH(iLink).d, 'a', DH(iLink).a, 'alpha', ...
                DH(iLink).alpha, 'm', m, 'r', rv, 'B', b, 'modified'); % Vector de estructuras Link
    end

    Tool = transl(L2, 0, 0); % Offset de la herramienta
    
    arm = SerialLink([links{:}], 'tool', Tool, 'name', 'botete');

end