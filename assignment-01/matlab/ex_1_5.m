classdef ex_1_5 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure        matlab.ui.Figure
        UIAxes          matlab.ui.control.UIAxes
        GenerateButton  matlab.ui.control.Button
        UIAxes2         matlab.ui.control.UIAxes
        UIAxes3         matlab.ui.control.UIAxes
        UIAxes4         matlab.ui.control.UIAxes
        fs1000Label     matlab.ui.control.Label
        fs160Label      matlab.ui.control.Label
        fs120Label      matlab.ui.control.Label
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: GenerateButton
        function GenerateButtonPushed(app, event)
            phase=2*pi*rand([1,3]);
            f1=10;  f2=20;  f3=100;
            fs=[1000 160 120];          % sampling frequencies
            ts=1/fs(1);
            t=0:ts:(1-ts);
            a=rectangularPulse(0,1,t);
            b=sin(2*pi*f1*t+phase(1))+sin(2*pi*f2*t+phase(2))+sin(2*pi*f3*t+phase(3));
            x=a.*b;
            
            plot(app.UIAxes,t,x);
            
            %%ffts
            N=length(x);
            Z=zeros(3,fs(1));           % ESD matrix
            for i=1:3;
                ts=1/fs(i);
                t=0:ts:(1-ts);
                a=rectangularPulse(0,1,t);
                b=sin(2*pi*f1*t+phase(1))+sin(2*pi*f2*t+phase(2))+sin(2*pi*f3*t+phase(3));
                x=a.*b;
                N(i)=length(x)
                X=fft(x)*ts;            % CTFT of sampled signals 
                Y=zeros(1,length(X));
                Y(1:(fs(i)/2))=X(fs(i)/2+1:end);
                Y(fs(i)/2+1:end)=X(1:(fs(i)/2));
                Z(i,1:fs(i))=Y;
            end
            f1=[-N(1)/2:(N(1)/2-1)]*(fs(1)/N(1));
            f2=[-N(2)/2:(N(2)/2-1)]*(fs(2)/N(2));
            f3=[-N(3)/2:(N(3)/2-1)]*(fs(3)/N(3));

            plot(app.UIAxes2,f1,abs(Z(1,1:fs(1))).^2);
            plot(app.UIAxes3,f2,abs(Z(2,1:fs(2))).^2);
            plot(app.UIAxes4,f3,abs(Z(3,1:fs(3))).^2);
  
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 919 457];
            app.UIFigure.Name = 'UI Figure';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'x(t)')
            xlabel(app.UIAxes, 'time')
            ylabel(app.UIAxes, 'amplitude')
            app.UIAxes.Position = [300 250 300 185];

            % Create GenerateButton
            app.GenerateButton = uibutton(app.UIFigure, 'push');
            app.GenerateButton.ButtonPushedFcn = createCallbackFcn(app, @GenerateButtonPushed, true);
            app.GenerateButton.Position = [101 371 100 22];
            app.GenerateButton.Text = 'Generate';

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.UIFigure);
            title(app.UIAxes2, 'X(f)')
            xlabel(app.UIAxes2, 'frequency')
            ylabel(app.UIAxes2, '|X(f)^2|')
            app.UIAxes2.Position = [1 66 300 185];

            % Create UIAxes3
            app.UIAxes3 = uiaxes(app.UIFigure);
            title(app.UIAxes3, 'X(f)')
            xlabel(app.UIAxes3, 'frequency')
            ylabel(app.UIAxes3, '|X(f)^2|')
            app.UIAxes3.Position = [300 66 300 185];

            % Create UIAxes4
            app.UIAxes4 = uiaxes(app.UIFigure);
            title(app.UIAxes4, 'X(f)')
            xlabel(app.UIAxes4, 'frequency')
            ylabel(app.UIAxes4, '|X(f)^2|')
            app.UIAxes4.Position = [609 66 300 185];

            % Create fs1000Label
            app.fs1000Label = uilabel(app.UIFigure);
            app.fs1000Label.Position = [144 45 49 22];
            app.fs1000Label.Text = 'fs=1000';

            % Create fs160Label
            app.fs160Label = uilabel(app.UIFigure);
            app.fs160Label.Position = [441 45 42 22];
            app.fs160Label.Text = 'fs=160';

            % Create fs120Label
            app.fs120Label = uilabel(app.UIFigure);
            app.fs120Label.Position = [753 45 42 22];
            app.fs120Label.Text = 'fs=120';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ex_1_5

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end