<step 1>
Open the figure file:

open('example.fig');

%or
figure;
plot(1:10)


<step 2>
Get a handle to the current figure:

h = gcf; %current figure handle


<step 3>
The data that is plotted is usually a 'child' of the Axes object. The axes objects are themselves children of the figure. You can go down their hierarchy as follows: 

axesObjs = get(h, 'Children'); %axes handles
dataObjs = get(axesObjs, 'Children'); %handles to low-level graphics objects in axes


<step 4>
Extract values from the dataObjs of your choice. You can check their type by typing:

objTypes = get(dataObjs, 'Type'); %type of low-level graphics object


* NOTE : Different objects like 'Line' and 'Surface' will store data differently. Based on the 'Type', you can search the documentation for how each type stores its data.

<step 5>
Lines of code similar to the following would be required to bring the data to MATLAB Workspace:
xdata = get(dataObjs, 'XData'); %data from low-level grahics objects
ydata = get(dataObjs, 'YData');
zdata = get(dataObjs, 'ZData');