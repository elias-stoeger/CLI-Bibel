# CLI Bibel
Eine deutsche Command Line Bibel mit Suchfunktion für den technisch minimalistischen Christen.

Es ist ein Rewrite und eine Fortsetzung von meinem Python Skript:
https://github.com/elias-stoeger/cli-bible-german

diesmal aber in Nim was die ganze PATH Geschichte leichter macht :)

Die Bibel hab ich von [thiagobodruk](https://github.com/thiagobodruk/bible) geborgt und um ein paar deutsche Namen erweitert, die Lizenz sollte daher wohl von deren Repo übernommen werden.

# Funktionen
die Namen der Bücher funktionieren auf Deutsch, Englisch oder als Abkürzung:
Johannes == John == jo

Um sich zu orientieren kann man ein Inhaltsverzeichnis ausgeben:
```
$ bibel Inhalt
```

Man kann Bücher ausgeben:
```
$ bibel Johannes
$ bibel John
$ bibel jo
```

Man kann Kapitel ausgeben:
```
$ bibel Johannes 1
```

Man kann einen Vers ausgeben ...
```
$ bibel John 1:20
```

oder mehrere Verse:
```
$ bibel jo 1:20-22
```

Und wenn man es ohne Argumente ausführt bekommt man einen zufälligen Vers:
```
$ bibel
```

Die Suche kann man als Terminal-Konkordanz sehen, sie sucht nach allen Stellen in denen alle mitgegebenen Begriffe vorkommen:
```
# okay sind suche, such und search
$ bibel Suche Jesus Petrus
```
Die Ausgabe ist im Format ...
```
Buch Kapitel, VersIndex:
Vers

John 13, 36:
Simon Petrus spricht zu ihm: Herr, wohin gehst du? Jesus antwortete ihm: Wohin ich gehe, dahin kannst du mir jetzt nicht folgen, du wirst mir aber später folgen.
```

# Installation

## Requirements
die aktuelle Nim Version
https://nim-lang.org/install.html

## Compilen
```
git clone https://github.com/elias-stoeger/CLI-Bibel.git
cd CLI-Bibel
nim c -r -d:release bibel.nim
```

danach möchtest du wahrscheinlich die Binary noch in den Pfad schieben, z.B.:
```
sudo mv bibel /usr/bin/
```

Falls sie dir zu langsam ist kannst du es auch mit der "danger" Flag versuchen:
```
nim c -r -d:danger bibel.nim
```
dann kann ich aber keine Garantie auf leibliches Wohl geben ... ;)
