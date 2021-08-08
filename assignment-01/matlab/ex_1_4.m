classdef ex_1_4 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure         matlab.ui.Figure
        generateButton   matlab.ui.control.Button
        UIAxes           matlab.ui.control.UIAxes
        AEditFieldLabel  matlab.ui.control.Label
        AEditField       matlab.ui.control.NumericEditField
        TEditFieldLabel  matlab.ui.control.Label
        TEditField       matlab.ui.control.NumericEditField
        FFTButton        matlab.ui.control.Button
        UIAxes2          matlab.ui.control.UIAxes
        UIAxes3          matlab.ui.control.UIAxes
        UIAxes4          matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        x;  % signal
        fs; % sampling frequency
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: generateButton
        function generateButtonPushed(app, event)
            A=app.AEditField.Value;
            T=app.TEditField.Value;
            Tmax=10*T;
            app.fs=1000/T;
            ts=1/app.fs;
            t=0:ts:(Tmax-ts);
            app.x=A*rectangularPulse(0,T,t);
            plot(app.UIAxes,t,app.x);
            xlim(app.UIAxes,[0 Tmax])
            % Energy
            Er=sum(app.x.^2)*ts;
            E=A^2*T;
            deltaE=Er-E;
        end

        % Button pushed function: FFTButton
        function FFTButtonPushed(app, event)
            A=app.AEditField.Value;
            T=app.TEditField.Value;
            X=fft(app.x);
            X=circshift(X,length(X)/2);
            app.fs=1000/T;
            ts=1/app.fs;
            N=length(app.x);
            f=[-N/2:(N/2-1)]*(app.fs/N);
            k=(A*T^2)/1000;         % normalization factor
            Xnrm=k*abs(X);
            plot(app.UIAxes2,f,Xnrm);
            xlim(app.UIAxes2,[-5/T 5/T]);
            
            %Energy
            app.fs=1000/T;
            df=app.fs/N;
            X=fft(app.x)*ts;        % CTFT approx
            Er=sum(abs(X).^2)*df;
            E=A^2*T;
            deltaE=Er-E;
            
            %Energy lobes
            Et=Er/2;
            k=1/(df*T);
            Elob1=X(1)^2*df;        % energy first lobe
            for i=(1:100)*k;
                El(i*(df*T))=Elob1/2+sum(abs(X(2:(i+1))).^2)*df;
            end
           
            plot(app.UIAxes3,1:10,El(1:10)/Et,'-o');
            xlim(app.UIAxes3,[1 10])
            plot(app.UIAxes4,10:100,El(10:100)/Et);
            xlim(app.UIAxes4,[10 100])
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 655 641];
            app.UIFigure.Name = 'UI Figure';

            % Create generateButton
            app.generateButton = uibutton(app.UIFigure, 'push');
            app.generateButton.ButtonPushedFcn = createCallbackFcn(app, @generateButtonPushed, true);
            app.generateButton.Position = [135 463 100 22];
            app.generateButton.Text = 'generate';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'x(t)')
            xlabel(app.UIAxes, 'time')
            ylabel(app.UIAxes, 'amplitude')
            app.UIAxes.PlotBoxAspectRatio = [1.94615384615385 1 1];
            app.UIAxes.Position = [303 426 300 185];

            % Create AEditFieldLabel
            app.AEditFieldLabel = uilabel(app.UIFigure);
            app.AEditFieldLabel.HorizontalAlignment = 'right';
            app.AEditFieldLabel.Position = [95 550 25 22];
            app.AEditFieldLabel.Text = 'A';

            % Create AEditField
            app.AEditField = uieditfield(app.UIFigure, 'numeric');
            app.AEditField.Position = [135 550 100 22];
            app.AEditField.Value = 1;

            % Create TEditFieldLabel
            app.TEditFieldLabel = uilabel(app.UIFigure);
            app.TEditFieldLabel.HorizontalAlignment = 'right';
            app.TEditFieldLabel.Position = [95 506 25 22];
            app.TEditFieldLabel.Text = 'T';

            % Create TEditField
            app.TEditField = uieditfield(app.UIFigure, 'numeric');
            app.TEditField.Limits = [1 3];
            app.TEditField.Position = [135 506 100 22];
            app.TEditField.Value = 1;

            % Create FFTButton
            app.FFTButton = uibutton(app.UIFigure, 'push');
            app.FFTButton.ButtonPushedFcn = createCallbackFcn(app, @FFTButtonPushed, true);
            app.FFTButton.Position = [135 375 100 22];
            app.FFTButton.Text = 'FFT';

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.UIFigure);
            title(app.UIAxes2, 'Fourier transform')
            xlabel(app.UIAxes2, 'frequency')
            ylabel(app.UIAxes2, 'amplitude')
            app.UIAxes2.PlotBoxAspectRatio = [1.94615384615385 1 1];
            app.UIAxes2.Position = [303 242 300 185];

            % Create UIAxes3
            app.UIAxes3 = uiaxes(app.UIFigure);
            title(app.UIAxes3, 'power ratio 1<n<10')
            xlabel(app.UIAxes3, 'number of lobes')
            ylabel(app.UIAxes3, 'energy percentage')
            app.UIAxes3.PlotBoxAspectRatio = [1.96850393700787 1 1];
            app.UIAxes3.Position = [4 36 300 185];

            % Create UIAxes4
            app.UIAxes4 = uiaxes(app.UIFigure);
            title(app.UIAxes4, 'power ratio 10<n<100')
            xlabel(app.UIAxes4, 'number of lobes')
            ylabel(app.UIAxes4, 'energy percentage')
            app.UIAxes4.PlotBoxAspectRatio = [1.96850393700787 1 1];
            app.UIAxes4.Position = [303 36 300 185];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ex_1_4

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