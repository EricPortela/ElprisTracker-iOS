
# ElprisTracker
En iOS applikation som skrapar dagens spotpriser för el från elen.nu. I skrivande stund enbart för elområde SE4, dock. Utveckling pågår och applikationen är därmed inte färdigställd. Applikationen ska tillhandahålla ett enkelt grafiskt användargränssnitt för man att överskådligt ska kunna anpassa sin elkonsumtion och förbruka som mest när timpriset är som lägst, givetvis förutsatt att man har ett timprisavtal.

![ElectricityTrackerMainPage@3x](https://user-images.githubusercontent.com/58792679/162829576-58d1dfaf-6ee9-4519-826a-8b74b8246198.png)

To do:

--> Grafisk representation av datan

--> Tidsbaserad avvisering då timpriset är som lägst

--> Jämförelser (med motsvarande dag för en vecka sedan), nyckeltal, etc.

--> Enkla kostnadsberäkningar för vardagliga elprylar

--> Potentiell elkostnad

--> Manuellt inlägg av olika sorters prispåslag (nätet, skatter, etc.)

Kör .xcworkspace filen.

Swiftsoup används för att "parse:a" data från hemsidan.
