# training_organizer

Der Training Organizer ist eine App um Prozesse in unserer Wasserwacht Ortsgruppe zu vereinfachen.

## Installation

Die App ist als Progressive Web App (PWA) implementiert und ist über <https://michaelsandner.github.io/training_organizer/> erreichbar und kann über die Browsereinstellungen auf mobile devices installiert werden.  
Durch die Installation ist die App auf dem Desktop des mobile devices verfügbar und fühlt sich wie eine mobile app an

## Features

### Performance Data

#### ICAL Kalender auslesen

Daten für die Jahresstatistik können aus einem ICAL file importiert werden. Dafür muss die ICAL file aus dem Kalender exportiert werden und in der Performance Data view eingelesen werden.  
Die ICAL file wird auf entsprechende Einträge durchsucht und fügt sie der Statistik als Einträge hinzu.
Damit die Einträge gelesen/gefunden werden können, muss `TAG` und `TEILNEHMENDE` in der Beschreibung des Kalnedertermins gesetzt sein.

**Beispiel:**  
`TAG:FORTBILDUNG`  
`TEILNEHMENDE:3`  

Großschreibung und Leerzeichen nach dem Doppelpunkt is ebenfalls erlaubt:

`tag: Fortbildung`  
`teilnehmende:3`  

**Berechnung der Einträge:**  
Dauer des Kalendereintrages * Anzahl der Teilnehmenden

#### Verfügbare Tags

`FORTBILDUNG`  
`NATURSCHUTZ`  
`GREMIENARBEIT`  
`SCHWIMMTRAINING`  
`GRUPPENSTUNDE`  
`SANDIENST`

## Daten

Es werden keine Daten an irgendwelche Server oder Drittanbieter gesendet.
Personenbezogene Daten die z.B. für die Verwaltung der Mitglieder verwendet werden, werden lediglich vom lokalen Device importiert und exportiert.
Für den Speicherort der Daten ist einzig und alleine der User verantwortlich.
