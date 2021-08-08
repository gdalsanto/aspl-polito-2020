classdef ex_1_3 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure        matlab.ui.Figure
        UIAxes2         matlab.ui.control.UIAxes
        UIAxes3         matlab.ui.control.UIAxes
        UIAxes4         matlab.ui.control.UIAxes
        UIAxes5         matlab.ui.control.UIAxes
        UIAxes6         matlab.ui.control.UIAxes
        generateButton  matlab.ui.control.Button
        UIAxes          matlab.ui.control.UIAxes
    end

    methods (Access = private)
        % Rectangular Pulse function
        % T width
        % t time axis
        function [y] = Pt(~,T,t)
            y=1*((t>=0)&(t<T));
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: generateButton
        function generateButtonPushed(app, event)
            fs=1e4;
            t=0:1/fs:1;
            N=100;                  % number of signals 
            s=zeros(N,length(t));
            for i=1:N
                phase=2*pi*rand;
                s(i,:)=app.Pt(1,t).*sin(2*pi*i*t+phase);
            end
            plot(app.UIAxes,t,s(10,:));
            plot(app.UIAxes2,t,s(20,:));
            plot(app.UIAxes3,t,s(100,:));
            plot(app.UIAxes4,t,sum(s(1:10,:)));
            plot(app.UIAxes5,t,sum(s(1:20,:)));
            plot(app.UIAxes6,t,sum(s(1:100,:)));
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 942 474];
            app.UIFigure.Name = 'UI Figure';

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.UIFigure);
            title(app.UIAxes2, 's_{20}(t)')
            xlabel(app.UIAxes2, 'time')
            ylabel(app.UIAxes2, 'amplitude')
            app.UIAxes2.Position = [300 264 300 185];

            % Create UIAxes3
            app.UIAxes3 = uiaxes(app.UIFigure);
            title(app.UIAxes3, 's_{100}(t)')
            xlabel(app.UIAxes3, 'time')
            ylabel(app.UIAxes3, 'amplitude')
            app.UIAxes3.Position = [599 264 300 185];

            % Create UIAxes4
            app.UIAxes4 = uiaxes(app.UIFigure);
            title(app.UIAxes4, 's_a(t)')
            xlabel(app.UIAxes4, 'time')
            ylabel(app.UIAxes4, 'amplitude')
            app.UIAxes4.Position = [1 41 300 185];

            % Create UIAxes5
            app.UIAxes5 = uiaxes(app.UIFigure);
            title(app.UIAxes5, 's_b(t)')
            xlabel(app.UIAxes5, 'time')
            ylabel(app.UIAxes5, 'amplitude')
            app.UIAxes5.Position = [300 41 300 185];

            % Create UIAxes6
            app.UIAxes6 = uiaxes(app.UIFigure);
            title(app.UIAxes6, 's_c(t)')
            xlabel(app.UIAxes6, 'time')
            ylabel(app.UIAxes6, 'amplitude')
            app.UIAxes6.Position = [599 41 300 185];

            % Create generateButton
            app.generateButton = uibutton(app.UIFigure, 'push');
            app.generateButton.ButtonPushedFcn = createCallbackFcn(app, @generateButtonPushed, true);
            app.generateButton.Position = [400 10 100 22];
            app.generateButton.Text = 'generate';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 's_{10}(t)')
            xlabel(app.UIAxes, 'time')
            ylabel(app.UIAxes, 'amplitude')
            app.UIAxes.Position = [1 264 300 185];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ex_1_3

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