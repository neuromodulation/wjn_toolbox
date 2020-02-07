classdef RealTimePlot < TMSi.HiddenHandle
    %REALTIMEPLOT Provides a very basic visualization of the data that can be sampled from a device.
    %
    %   Closing of the plot can be done with the key 'q' or through closing the figure. Scaling of the
    %   individual channels can be done with the key 'a'. Scaling will scale the channels to min-max.
    %   Set a fixed range can be done with the key 'r'. A dialog will show
    %   where you can enter the +/- uV range.
    %
    %REALTIMEPLOT Properties:
    %   is_visible - If plot is ready to be used (i.e. appended to).
    %   window_size - The time period of the plot.
    %   channels - A list of numbers representing the channels that are to be displayed.
    %   name - Name of this GUI.
    %   sample_rate - The sample rate of the sampled data.
    %   figure - The figure handle used.
    %
    %REALTIMEPLOT Methods:
    %   RealTimePlot - Constructor for the RealTimePlot class.
    %   setWindowSize - Set the size of the x-axis in seconds.
    %   append - Add samples to the RealTimePlot.
    %   show - Show the figure in which the data is going to be displayed.
    %   hide - Destroy the current figure object associated with this object.
    %   draw - Updates the current figure with the newly appended data.
    %
    %REALTIMEPLOT Example:
    %   sampler = device.createSampler();
    %   realTimePlot = TMSi.RealTimePlot('Example', sampler.sample_rate, sampler.device.channels);
    %   realTimePlot.show();
    %
    %   sampler.connect();
    %   sampler.start();
    %   while realTimePlot.is_visible
    %       samples = sampler.sample();
    %       realTimePlot.append(samples);
    %   end
    %   sampler.stop();
    %   sampler.disconnect();
    
    properties (SetAccess = private)
        % If GUI is visible, not stopped.
        is_visible
        
        % The time period of the plot.
        window_size
       
        % A list of numbers representing the channels that are to be displayed.
        channels
        
        % Name of this GUI.
        name
        
        % The sample rate of the sampled data.
        sample_rate
        
        % The figure handle used.
        figure
    end
    
    properties(Access = private)
        % A internal buffer used to store the samples required for displaying.
        window_buffer
        
        % Number of samples seen so far in the GUI.
        samples_seen
        
        % The factor with which the shown data is downsampled.
        downsample_factor
        
        % List of axes for each chanel
        axes_list
        
        % List of plots for each channel
        plot_list
        
        % The plot handle used.
        plot
        
        % The axes handle used.
        axes_left
        
        % The axes handle used.
        axes_right
    end
    
    methods
        function obj = RealTimePlot(name, sample_rate, channels)
            %REALTIMEPLOT - Constructor for the RealTimePlot class.
            %
            %   Constructor for the RealTimePlot class, will use the sampler object to sample
            %   from.
            
            obj.name = name;
            obj.sample_rate = sample_rate;
            obj.channels = channels;
            obj.is_visible = false;
            obj.window_size = 5;
            obj.window_buffer = [];
            obj.samples_seen = 0;
            obj.downsample_factor = obj.downSamplingFactor(4096, 4096);
            
            obj.window_buffer = nan(numel(obj.channels), ceil(obj.window_size * obj.sample_rate));
        end
        
        function show(obj)
            %SHOW - Show the figure in which the data is going to be displayed.
            
            if obj.is_visible
                return;
            end
            
            % ==================================================================
            %   FIGURE
            % ==================================================================
            obj.figure = figure('Name', obj.name);
            set(obj.figure, 'CloseRequestFcn', @obj.closeRequestEvent);
            set(obj.figure, 'KeyReleaseFcn', @obj.keyReleaseEvent);
            set(obj.figure, 'ResizeFcn', @obj.resizeEvent);
            
            % ==================================================================
            %   AXES LEFT
            % ==================================================================
            position = [0, 0, 1, 1];
            obj.axes_left = axes('OuterPosition', position);
            
            set(obj.axes_left, 'XLim', [0 obj.window_size]);
            set(obj.axes_left, 'YLim', [0 size(obj.window_buffer, 1) * 2]);
            set(obj.axes_left, 'YTick', 1:2:size(obj.window_buffer, 1)*2);
            
            set(obj.axes_left, 'Box', 'on');
            set(obj.axes_left, 'XGrid', 'on');
            set(obj.axes_left, 'YGrid', 'on');
            %set(obj.axes_left, 'XMinorGrid', 'on');
            %set(obj.axes_left, 'YMinorGrid', 'on');
            
            YTick = {};
            for i=1:size(obj.window_buffer, 1)
                YTick{size(obj.window_buffer, 1) - i + 1} = obj.channels{i}.name;
            end
            
            set(obj.axes_left, 'YTickLabel', YTick);
            
            xlabel('Time (s)');
            ylabel('Channels');
            
            % ==================================================================
            %   AXES RIGHT
            % ==================================================================
            obj.axes_right = axes('Position', get(obj.axes_left, 'Position'));
            set(obj.axes_right, 'XLim', [0 obj.window_size]);
            set(obj.axes_right, 'YLim', [0 size(obj.window_buffer, 1) * 4]);
            set(obj.axes_right, 'YTick', 0:size(obj.window_buffer, 1) * 4);
            set(obj.axes_right, 'Color', 'none');
            set(obj.axes_right, 'XTick', []);
            set(obj.axes_right, 'YAxisLocation', 'right');
            
            % ==================================================================
            %   CHANNELS
            % ==================================================================
            obj.axes_list = [];
            obj.plot_list = [];
            
            YTick_right = {};
            for i=1:size(obj.window_buffer, 1)
                obj.axes_list(i) = axes('Position', get(obj.axes_left, 'Position'));
                obj.plot_list(i) = plot(1:10);
                set(obj.axes_list(i), 'XTick', []);
                set(obj.axes_list(i), 'YTick', []);
                set(obj.axes_list(i), 'Color', 'none');
                
                value_d = 2^31;
                value_mean = 0;
                
                set(obj.axes_list(i), 'XLim', [0 obj.window_size]);
                set(obj.axes_list(i), 'YLim', [value_mean - ((size(obj.window_buffer, 1) - i + 1) - 0.5) * value_d, value_mean + (size(obj.window_buffer, 1) - (size(obj.window_buffer, 1) - i + 1) + 0.5) * value_d]);
                
                YTick_right{size(obj.window_buffer, 1) * 4 - ((i - 1) * 4 + 1) + 2} = '';
                YTick_right{size(obj.window_buffer, 1) * 4 - ((i - 1) * 4 + 2) + 2} = sprintf('%0.2e', value_mean + value_d);
                YTick_right{size(obj.window_buffer, 1) * 4 - ((i - 1) * 4 + 3) + 2} = sprintf([obj.channels{i}.unit_name]);
                YTick_right{size(obj.window_buffer, 1) * 4 - (i * 4) + 2} = sprintf('%0.5e', value_mean - value_d);
            end
            set(obj.axes_right, 'YTickLabel', YTick_right, 'FontSize',7);
            
            position = get(obj.figure, 'Position');
            obj.downsample_factor = obj.downSamplingFactor(position(3), position(4));
            
            obj.is_visible = true;
        end
        
        function hide(obj)
            %HIDE - Destroy the current figure object associated with this object.
            
            if ~obj.is_visible
                return;
            end
            
            delete(obj.figure);
            
            obj.figure = 0;
            obj.axes_left = 0;
            obj.axes_list = [];
            obj.plot_list = [];
            
            obj.is_visible = false;
        end
        
        function append(obj, samples)
            %APPEND - Add samples to the RealTimePlot.
            %
            %   Give samples to the RealTimePlot. Make sure that samples contains only the channels you specified
            %   at creation of this object.
            
            if size(samples, 2) > 0
                if size(samples, 1) > numel(obj.channels)
                    throw(MException('RealTimePlot:append', 'Too many channels.'));
                end
                
                white_out = floor(obj.window_size * obj.sample_rate * 0.05);
                indices = mod(obj.samples_seen + (1:size(samples, 2) + white_out) - 1, size(obj.window_buffer, 2)) + 1;
                obj.window_buffer(:, indices(1:end-white_out)) = samples;
                obj.window_buffer(:, indices(end-white_out + 1:end)) = NaN;
            end
            
            obj.samples_seen = obj.samples_seen + size(samples, 2);
        end
        
        function draw(obj)
            %DRAW - Updates the current figure with the newly appended data.
            
            if ~obj.is_visible
                obj.show();
            end
            
            y_data_raw = obj.window_buffer(:, 1:obj.downsample_factor:end);
            x_axes = (1:size(y_data_raw, 2)) * (1 / size(y_data_raw, 2) * obj.window_size);
            
            for i=1:numel(obj.channels)
                set(obj.plot_list(i), 'XData', x_axes, 'YData', y_data_raw(i, :));
            end
            
            drawnow;
        end
        
        function setWindowSize(obj, seconds)
            %SETWINDOWSIZE - Set the size of the x-axis in seconds.
            %
            %   By default the windows size is set to 5 seconds.
            %
            %   seconds - The size of x-axis in seconds.
            
            obj.window_size = seconds;
            obj.window_buffer = nan(numel(obj.channels), ceil(obj.window_size * obj.sample_rate));
        end
        

    end
    
    methods(Access = private)
        function keyReleaseEvent(obj, ~, event)
            %KEYRELEASEEVENT - A callback function used to identify the quit event.
            %
            %   Currently, only key 'q' is acceppted and is used to close the
            %   plotting properly.
            
            if event.Key == 'q'
                obj.hide();
            end
            
            if event.Key == 'a'
                YTick_right = get(obj.axes_right, 'YTickLabel');
                
                for i=1:size(obj.window_buffer, 1)
                    value_min = min(obj.window_buffer(i, :));
                    value_max = max(obj.window_buffer(i, :));
                    value_d = value_max - value_min;
                    value_mean = (value_min + value_max) / 2;
                    
                    % Cannot have a limit from 0 to 0.
                    if value_d == 0 || isnan(value_d)
                        value_d = 2^31;
                    end
                    
                    if isnan(value_mean)
                        value_mean = 0;
                    end
                    
                    value_d = value_d * 1.05;
                    
                    set(obj.axes_list(i), 'YLim', [value_mean - ((size(obj.window_buffer, 1) - i + 1) - 0.5) * value_d, value_mean + (size(obj.window_buffer, 1) - (size(obj.window_buffer, 1) - i + 1) + 0.5) * value_d]);
                    YTick_right{size(obj.window_buffer, 1) * 4 - ((i - 1) * 4 + 2) + 2} = sprintf('%0.5e', value_mean + value_d / 4);
                    YTick_right{size(obj.window_buffer, 1) * 4 - i * 4 + 2} = sprintf('%0.5e', value_mean - value_d / 4);
                end
                set(obj.axes_right, 'YTickLabel', YTick_right);
            end
            
            % set range key
            if event.Key == 'r'
                
                r = inputdlg('Enter desired signal range [uV]:',...
                    'Amplitude Range', [1 50]);
                range = str2num(r{:});
                
                YTick_right = get(obj.axes_right, 'YTickLabel');
                
                for i=1:size(obj.window_buffer, 1)
                    
                    value_d = range;
                    
                    value_min = range/2 *-1;
                    value_max = range/2;
                    value_mean = 0;
                    
                    %                     value_mean = (value_min + value_max) / 2;
                    
                    % Cannot have a limit from 0 to 0.
                    if value_d == 0 || isnan(value_d)
                        value_d = 2^31;
                    end
                    
                    if isnan(value_mean)
                        value_mean = 0;
                    end
                    
                    %                     value_d = value_d * 1.05;
                    
                    set(obj.axes_list(i), 'YLim', [value_mean - ((size(obj.window_buffer, 1) - i + 1) - 0.5) * value_d, value_mean + (size(obj.window_buffer, 1) - (size(obj.window_buffer, 1) - i + 1) + 0.5) * value_d]);
                    YTick_right{size(obj.window_buffer, 1) * 4 - ((i - 1) * 4 + 2) + 2} = sprintf('%+.2f', value_mean + value_d);
                    YTick_right{size(obj.window_buffer, 1) * 4 - i * 4 + 2} = sprintf('%+.2f', value_mean - value_d);
                end
                set(obj.axes_right, 'YTickLabel', YTick_right);
            end
            
        end
        
        function closeRequestEvent(obj, ~, ~)
            %KEYRELEASEEVENT - A callback function used to identify the quit event.
            %
            %   Currently, only key 'q' is acceppted and is used to close the
            %   plotting properly.
            
            obj.hide();
        end
        
        function resizeEvent(obj, src, ~)
            %RESIZEEVENT - A callback that changes the downsample factor when resizing.
            %
            %   The downsample factor causes the data points to be reduced to 2 samples
            %   per pixel on the screen.
            
            position = get(src, 'Position');
            obj.downsample_factor = obj.downSamplingFactor(position(3), position(4));
            
            set(obj.axes_right, 'Position', get(obj.axes_left, 'Position'));
            
            for i=1:numel(obj.axes_list)
                set(obj.axes_list, 'Position', get(obj.axes_left, 'Position'));
            end
        end
        
        function downsample = downSamplingFactor(obj, width, height)
            %DOWNSAMPLINGFACTOR - A dynamic factor that should range somewhere between 15 and 1.
            
            downsample = ceil(obj.window_size * obj.sample_rate / (width * 4));
        end
    end
end