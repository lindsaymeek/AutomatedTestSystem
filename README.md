# AutomatedTestSystem
This project describes an automated test system that has been constructed using the PSOC controller as the main programmable building block.

The test system consists of a string of test pod units, each with a PSOC controller. 

These test pods are daisy-chained together in a bus arrangement to create enough analog and digital I/O to exercise a device-under-test. 
The pods connect to the device-under-test using a HP logic analyser compatible 40-way connector. 

The test pod bus is interfaced to a PC, which interprets a test-vector scripting language, and translates it to low level commands. 
These commands are then sent to the test pods, and any measured values checked against the expected values to verify that the 
device-under-test is operating as expected. 

The scripting language supports dynamic reconfiguration of pins of the PSOC devices, as either digital input, strong digital output, 
pulled-up digital output, pulled-down digital output, analog output, or analog input. The pins configurations may be altered from one
test vector to the next, increasing the depth of tests that are possible, and reducing the need for custom hardware to be developed 
for each new test procedure.
