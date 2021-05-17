import numpy as np
from  keithley2600 import Keithley2600 # voltage source https://github.com/OE-FET/keithley2600
from instrumental import instrument, list_instruments # thorlabs ccs
from pymeasure.instruments.lakeshore import LakeShore331 # temperature controller https://pymeasure.readthedocs.io/en/latest/api/instruments/lakeshore/lakeshore331.html
from time import sleep

tempinc = 5 # temperature increment in Kelvin
temp_min = 180 # min temp in kelvin
temp_max = 275 # max temp in Kelvin
waittime = 60 # time to wait in seconds after temp is reached
LED_voltage = 20 # in Volts on channel B
LED_curr = 1.5 # in Amps, channel B

# configure temperature array
temps = np.arange(temp_max, temp_min - tempinc, -tempinc)
temps = temps[0:-1] + temps[::-1]
ntemps = len(temps)

# Save temperature data
fp.open('Data/temps.csv', 'a')
fp.write(temps)
fp.close()


temp_measurements = np.zeros([ntemps, 2])
# SETUP
temp_controller = LakeShore331("tc_interface")
V_controller = Keithly2600("LED_interface")


for i, currTemp in enumerate(temps):

    # set to currTemp and wait 
    temp_controller.setpoint_1 = currtemp

    try:    
        # force the program to wait until probe A reads within 0.1% of currtemp
        temp_controller.wait_for_temperature()
    except BaseException as e:
        print(e)
        print("Most likely, temperature did not stabilise at", currtemp,"K after 10 mins, continuing anyway")

    # wait extra time to ensure everything is at the right temp
    sleep(waittime)

    pre_temp = temperature_controller.temperature_A

    # turn on light
    # voltage controller
    V_controller.apply_voltage(V_controller.smub, LED_voltage)

    # ccs_read()

    # save temp spectrum

    # VC off
    V_controller.apply_voltage(V_controller.smub, 0)

    # post LED temp measurement
    post_temp = temperature_controller.temperature_A

    # save temps
    temp_measurements(i,1) = pre_temp;
    temp_measurements(i,2) = post_temp;

    fp = open('Data/' + str(currtemp) + 'K_temps.csv', 'a')
    fp.write(str(pre_temp)+ ', ' + str(post_temp))
    fp.close(()
