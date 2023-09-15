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
t6 = turbulent(r, 1, v, 6);
t7 = turbulent(r, 1, v, 7);
t8 = turbulent(r, 1, v, 8);

figure;
plot(r, p);
hold on;
plot(r, l, 'LineWidth', 1.5);
plot(r, t6, 'LineWidth', 1.5);
plot(r, t7, 'LineWidth', 1.5);
plot(r, t8, 'LineWidth', 1.5);
hold off;
set(gca, 'FontName', 'Times', 'FontSize', 14);
xlabel("Normalised radius, $r/R$", 'Interpreter', 'latex');
ylabel("Local Velocity /ms\textsuperscript{-1}", 'Interpreter', 'latex');
legend("Plug", 'Laminar', 'Turbulent, $n=6$', 'Tubulent, $n=7$', 'Turbulent, $n=8$', 'Interpreter', 'latex');

