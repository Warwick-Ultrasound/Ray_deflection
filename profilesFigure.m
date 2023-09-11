%{
A script for plotting the profiles figure for the paper
%}

clear;
clc;
close all;

N = 1000;

v = 1;
r = linspace(0, 1, N); % normalised radial coord

p = plug(r, 1, v);
l = laminar(r, 1, v);
t7 = turbulent(r, 1, v, 7);
t8 = turbulent(r, 1, v, 8);
t9 = turbulent(r, 1, v, 9);

figure;
plot(r, p);
hold on;
plot(r, l);
plot(r, t7);
plot(r, t8);
plot(r, t9);
hold off;
set(gca, 'FontName', 'Times', 'FontSize', 14);
xlabel("Normalised radius, $r/R$", 'Interpreter', 'latex');
ylabel("Local Velocity /ms\textsuperscript{-1}", 'Interpreter', 'latex');
legend("Plug", 'Laminar', 'Turbulent, $n=7$', 'Tubulent, $n=8$', 'Turbulent, $n=9$', 'Interpreter', 'latex');

