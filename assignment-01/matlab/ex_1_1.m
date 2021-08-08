classdef ex_1_1 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                 matlab.ui.Figure
        UIAxes                   matlab.ui.control.UIAxes
        generateButton           matlab.ui.control.Button
        frequencyEditFieldLabel  matlab.ui.control.Label
        frequencyEditField       matlab.ui.control.NumericEditField
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
            phase=2*pi*rand;
            f0=app.frequencyEditField.Value;    % signal frequency
            fs=1e4;                             % sampling frequency
            t=-1:1/fs:2;                       
            s=app.Pt(1,t).*sin(2*pi*f0*t+phase);
            plot(app.UIAxes,t,s)
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'UI Figure';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'sinusoidal signal s(t)')
            xlabel(app.UIAxes, 'time')
            ylabel(app.UIAxes, 'amplitude')
            app.UIAxes.Position = [233 117 367 274];

            % Create generateButton
            app.generateButton = uibutton(app.UIFigure, 'push');
            app.generateButton.ButtonPushedFcn = createCallbackFcn(app, @generateButtonPushed, true);
            app.generateButton.Position = [105 230 100 22];
            app.generateButton.Text = 'generate';

            % Create frequencyEditFieldLabel
            app.frequencyEditFieldLabel = uilabel(app.UIFigure);
            app.frequencyEditFieldLabel.HorizontalAlignment = 'right';
            app.frequencyEditFieldLabel.Position = [32 270 58 22];
            app.frequencyEditFieldLabel.Text = 'frequency';

            % Create frequencyEditField
            app.frequencyEditField = uieditfield(app.UIFigure, 'numeric');
            app.frequencyEditField.Limits = [1 10];
            app.frequencyEditField.Position = [105 270 100 22];
            app.frequencyEditField.Value = 1;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ex_1_1

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