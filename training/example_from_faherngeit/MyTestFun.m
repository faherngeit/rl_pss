function I_res = MyTestFun(I_meas)
I_res = (I_meas.Ideal + I_meas.Meas) / 2;
end