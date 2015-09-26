Diese wiki Seite richtet sich an alle die mocca selbst kompilieren. Sie beschreibt die Einrichtung der Entwicklungsumgebeung lazarus.

# Systemvoraussetzungen #

Auf dem System sollte eine Standard c/c++ Entwicklungsumgebung installiert sein mit den erforderlichen Libraries.

# Ubuntu Paketquellen #

  * Synaptic aufrufen
  * Menü: "Einstellungen - Paketquellen"
  * den Reiter "Software von Drittanbietern" wählen
  * "+ hinzufügen" klicken
  * In die APT Zeile 'deb http://www.hu.freepascal.org/lazarus/ lazarus-stable universe' eingeben
  * "+ Paketquellen hinzufügen" klicken

Es sollte jetzt eine neue Zeile 'http://www.hu.freepascal.org/lazarus/ lazarus-stable universe' sichtbar sein. Klickt man diese Zeile an und wählt "Bearbeiten", sollte folgendes zu sehen sein:
  * Type: binary
  * Addresse: http://www.hu.freepascal.org/lazarus/
  * Distribution: lazarus-stable
  * Komponente: universe

Das Menü "Software Paketquellen" mit "Close" verlassen

# Installieren #

In Synaptic den Auswahl-Button "Ursprung" klicken. Unter anderem sollten jetzt im linken Fenster folgende Quellen zur Auswahl stehen

  * www.hu.freepascal.org/main
  * www.hu.freepascal.org/universe

Aus www.hu.freepascal.org/universe (fast) alles installieren (Ausnahmen: fp-units-i386 **nicht**, fp-docs optional)

Aus www.hu.freepascal.org/main (mindestens) folgendes installieren:
  * lazarus-doc 0.9.28.2-0
  * lazarus-ide 0.9.28.2-0
  * lazarus-src 0.9.28.2-0

Daneben braucht man noch:
  * freeglut3
  * freeglut3-dbg
  * freeglut3-dev

Per default kommt lazarus mit gtk2. Eventuell müssen da auch noch libraries nachinstalliert werden ?
Falls gtk gewünscht wird, noch folgendes installieren:
  * libgtk1.2
  * libgtk1.2-common
  * libgtk1.2-dev
  * libglib1.2ldbl
  * libglib1.2ldbl-dbg
  * libglib1.2ldbl-dev
  * libgdk\_pixbuf2
  * libgdk\_pixbuf-dev


# Konfigurieren #

## nur gtk2 ##

Damit das kompilieren funktioniert:

sudo chmod a+w /usr/lib/lazarus/0.9.28.2/components/opengl

In lazaraus, "Menü Packages - Installierte Packages einrichten"

LazOpenGLContext 0.01 als package hinzufügen, kompilieren

Achtung: falls das kompilieren aus irgendeinem Grund nicht geklappt hat, reicht es nicht das Hindernis zu beseitigen und nochmal kompilieren. Man muss dann das Paket wieder abwählen, den Dialog mit "... speichern ..." verlassen, wieder aufrufen und das Paket erneut hinzufügen und kompilieren.

Ergebnis kontrollieren: Es sollte jetzt ein Verzeichnis "/usr/lib/lazarus/0.9.28.2/components/opengl/lib/i386-linux/gtk2" geben, mit einigen .o und .ppu Dateien.

## optional gtk ##

LCL kompilieren ??? TBD