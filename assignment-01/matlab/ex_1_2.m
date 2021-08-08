classdef ex_1_2 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure          matlab.ui.Figure
        UIAxes_3          matlab.ui.control.UIAxes
        UIAxes_2          matlab.ui.control.UIAxes
        T11A11D10Label    matlab.ui.control.Label
        T2EditFieldLabel  matlab.ui.control.Label
        T2EditField       matlab.ui.control.NumericEditField
        A2EditFieldLabel  matlab.ui.control.Label
        A2EditField       matlab.ui.control.NumericEditField
        D2EditFieldLabel  matlab.ui.control.Label
        D2EditField       matlab.ui.control.NumericEditField
        EvaluateButton    matlab.ui.control.Button
        UIAxes            matlab.ui.control.UIAxes
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

        % Button pushed function: EvaluateButton
        function EvaluateButtonPushed(app, event)
            fs=1e3;             % sampling frequency
            ts=1/fs;            
            t=0:ts:10;
            s1=app.Pt(1,t);
            s2=app.A2EditField.Value*app.Pt(app.T2EditField.Value,t-app.D2EditField.Value);
            s3=conv(s1,s2)*ts;     % convolution
            plot(app.UIAxes,t,s1);
            plot(app.UIAxes_2,t,s2);
            plot(app.UIAxes_3,t,s3(1:10/ts+1));        
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 648 633];
            app.UIFigure.Name = 'UI Figure';

            % Create UIAxes_3
            app.UIAxes_3 = uiaxes(app.UIFigure);
            title(app.UIAxes_3, 'convolution s_3(t)')
            xlabel(app.UIAxes_3, 'time')
            ylabel(app.UIAxes_3, 'amplitude')
            app.UIAxes_3.Position = [334 29 280 177];

            % Create UIAxes_2
            app.UIAxes_2 = uiaxes(app.UIFigure);
            title(app.UIAxes_2, 's_2(t)')
            xlabel(app.UIAxes_2, 'time')
            ylabel(app.UIAxes_2, 'amplitude')
            app.UIAxes_2.Position = [334 228 280 177];

            % Create T11A11D10Label
            app.T11A11D10Label = uilabel(app.UIFigure);
            app.T11A11D10Label.Position = [152 499 97 22];
            app.T11A11D10Label.Text = 'T1=1 A1=1 D1=0';

            % Create T2EditFieldLabel
            app.T2EditFieldLabel = uilabel(app.UIFigure);
            app.T2EditFieldLabel.HorizontalAlignment = 'right';
            app.T2EditFieldLabel.Position = [111 350 25 22];
            app.T2EditFieldLabel.Text = 'T2';

            % Create T2EditField
            app.T2EditField = uieditfield(app.UIFigure, 'numeric');
            app.T2EditField.Limits = [0 3];
            app.T2EditField.Position = [151 350 100 22];
            app.T2EditField.Value = 1;

            % Create A2EditFieldLabel
            app.A2EditFieldLabel = uilabel(app.UIFigure);
            app.A2EditFieldLabel.HorizontalAlignment = 'right';
            app.A2EditFieldLabel.Position = [111 317 25 22];
            app.A2EditFieldLabel.Text = 'A2';

            % Create A2EditField
            app.A2EditField = uieditfield(app.UIFigure, 'numeric');
            app.A2EditField.Limits = [1 4];
            app.A2EditField.Position = [151 317 100 22];
            app.A2EditField.Value = 1;

            % Create D2EditFieldLabel
            app.D2EditFieldLabel = uilabel(app.UIFigure);
            app.D2EditFieldLabel.HorizontalAlignment = 'right';
            app.D2EditFieldLabel.Position = [111 286 25 22];
            app.D2EditFieldLabel.Text = 'D2';

            % Create D2EditField
            app.D2EditField = uieditfield(app.UIFigure, 'numeric');
            app.D2EditField.Limits = [0 4];
            app.D2EditField.Position = [151 284 100 22];

            % Create EvaluateButton
            app.EvaluateButton = uibutton(app.UIFigure, 'push');
            app.EvaluateButton.ButtonPushedFcn = createCallbackFcn(app, @EvaluateButtonPushed, true);
            app.EvaluateButton.Position = [152 106 100 22];
            app.EvaluateButton.Text = 'Evaluate';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 's_1(t)')
            xlabel(app.UIAxes, 'time')
            ylabel(app.UIAxes, 'amplitude')
            app.UIAxes.Position = [334 422 280 177];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ex_1_2

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