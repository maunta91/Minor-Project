**# VLC Based Indoor Positioning System with Cameraphone**



**\*\*Tribhuvan University — Institute of Engineering, Pulchowk Campus\*\***

**BE Minor Project | Department of Electronics \& Computer Engineering**

**Cluster: Antenna and Communication**



**## Team**



**- Maunata Pulami (PUL080BEI023)**

**- Rakesh Yadav (PUL080BEI031)**

**- Rison Maharjan (PUL080BEI033)**



**## Overview**



**This project implements an indoor positioning system using \*\*Visible Light Communication (VLC)\*\*. Arduino-controlled LED transmitters blink a unique location identifier that is invisible flicker to the human eye but detectable by a smartphone camera. A Flutter mobile application decodes the signal and displays the user's current indoor location.**



**GPS does not work reliably indoors. This project explores a low-cost, energy-efficient alternative using infrastructure that's already in place: LED lighting and smartphone cameras.**



**## Architecture**



**Transmitter Layer (Arduino + LED)**

**down visible light, ON/OFF modulation**

**Optical Communication Layer**

**down camera captures frames**

**Receiver Layer (Smartphone Camera)**

**down brightness to bits to ID**

**Application Layer (Flutter App)**

**decode, lookup, display location**





**## How It Works**



**1. Each LED node transmits a fixed preamble (1010101) followed by a unique 8-bit location ID, encoded as LED ON (1) / OFF (0).**

**2. The phone's camera captures live frames and measures the average brightness of a small central region (the aiming box).**

**3. A rolling buffer of brightness readings is converted into a bitstream using a dynamic threshold.**

**4. The app searches the bitstream for the preamble, extracts the following 8 bits as the ID, and matches it against a known location table.**

**5. The detected location is displayed on screen and can be logged for later analysis.**



**## Repository Structure**



**Minor-Project/**

**- flutter\_app/  (Mobile application - Flutter)**

**- backend/      (Reserved - currently unused)**

**- arduino/      (LED transmitter firmware)**

**- docs/         (Report, diagrams, references)**



**## Flutter App**



**Located in flutter\_app/.**



**Key files:**

**- lib/main.dart - App entry point**

**- lib/screens/camera\_screen.dart - Camera preview, live detection UI**

**- lib/screens/results\_screen.dart - View and export logged readings**

**- lib/services/brightness\_service.dart - Extracts brightness from camera frame**

**- lib/services/vlc\_decoder.dart - Converts brightness samples into bitstream**

**- lib/services/id\_extractor.dart - Finds preamble and extracts location ID**

**- lib/services/location\_service.dart - Maps decoded ID to location name**



**Running the app:**

**cd flutter\_app**

**flutter pub get**

**flutter run**



**## Arduino Transmitter**



**Circuit:**

**Arduino Pin 13 to 220-330 ohm resistor to LED anode**

**LED cathode to Arduino GND**



**Location IDs:**

**- 00001010 = Room 101**

**- 00001011 = Library Entrance**

**- 00001100 = Lab 3**



**## Current Status**



**- Camera capture and brightness extraction: Done**

**- Bitstream decoding: Done**

**- Preamble detection and ID extraction: Done**

**- Location lookup and display: Done**

**- Results logging with CSV export: Done**

**- Arduino LED transmitter tested: Done**

**- Multi-node testing: In progress**

**- Full evaluation across conditions: In progress**



**## Screenshots**





**\[App Detection](docs/images/app.jpg)**



**### Test results log**

**\[Results Screen](docs/images/result.jpg)**



**### Arduino LED transmitter setup**

**\[Arduino Setup](docs/images/setup.jpg)**

**### led**

**\[led setup](docs/images/led.jpg)**



**\[led1](docs/images/l.jpg)**





