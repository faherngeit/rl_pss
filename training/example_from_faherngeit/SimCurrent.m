function [I, T_switch] = SimCurrent(nominal_current, fault_rate, fault_angle, fault_angle_shft, aper_time_const, period_count_norm, period_count_fault)
Ts = 10e-6;
w = 2 * pi * 50;
period_time = 0.02;
T_base = period_count_norm * period_time;
time_shift = round(period_time * fault_angle / 360 / Ts) * Ts;
T_switch = T_base + time_shift;


t_nom = 0:Ts:T_switch;
t_fault = T_switch:Ts:T_base + period_count_fault * period_time;

i_nom = nominal_current * sin(w * t_nom);
i_per = fault_rate * nominal_current * sin(w * t_fault - deg2rad(fault_angle_shft));

aper_mag = i_nom(end) - i_per(1);
i_aper = aper_mag * exp(-1 * (t_fault - T_switch) / aper_time_const);

i_fault = i_aper + i_per;

% I_nom = timeseries(i_nom, t_nom);
% I_fault = timeseries(i_fault, t_fault);
I = timeseries([i_nom(1:end), i_fault(2:end)], [t_nom(1:end), t_fault(2:end)]);