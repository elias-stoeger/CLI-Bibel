import std/json
import std/random
import strformat
import strutils
import system
import os

# echt cool, embeddet die JSON Bibel in der Binary
const bible_raw = staticRead("de_schlachter.json")

# Ich initialisiere den Radomizer, sonst kommt immer das Gleiche
randomize()

# Anzahl der mitgegebenen Werte
let param_num = paramCount()

let bible = parseJson(bible_raw)

try:
  var input: seq[string]
  for i in 0..2:
    input.add("-nope-")

  for i in 0..param_num:
    if i < 3 and input[i] == "-nope-":
      input[i] = paramStr(i)
    else:
      input.add(paramStr(i))

  if param_num > 2 and not (input[1].capitalizeAscii in ["Suche", "Such", "Search"]):
    raise newException(IOError, "Nicht gefunden")

  var found = false

  # Wenn ohne Argumente aufgerufen, zeig einen zufälligen Vers
  if input[1] == "-nope-":
    let book = rand(0..len(bible)-1)
    let chap = rand(0..len(bible[book]["chapters"])-1)
    let vers = rand(0..len(bible[book]["chapters"][chap])-1)

    found = true

    echo bible[book]["chapters"][chap][vers].getStr()

  elif capitalizeAscii(input[1]) == "Inhalt":
    for book in bible:
      if book.hasKey("name_ger"):
        echo book["name"].getStr(), " / ", book["name_ger"].getStr(),
          "  ", book["abbrev"].getStr()
        found = true

  elif capitalizeAscii(input[1]) in ["Suche", "Such", "Search"]:
    var searchList = input[2..input.len - 1]
    var finding: seq[string]

    for book in bible:
      var chapCount = 1
      for chapter in book["chapters"]:
        var verseCount = 1
        for verse in chapter:
          var foundX = searchList.len
          for word in searchList:
            if word in verse.getStr() or word.capitalizeAscii() in verse.getStr():
              foundX -= 1
          if foundX == 0:
            finding.add(book["name"].getStr() & " " & $chapCount &  ", " & $verseCount & ":")
            finding.add(verse.getStr() & "\n")

          verseCount += 1
        chapCount += 1


    if finding.len != 0:
      for entry in finding:
        echo entry
    else:
      echo "Keine passenden Verse gefunden ..."
    found = true

  elif input[2] == "-nope-":
    var counter : int8
    for book in bible:
      if book["name"].getStr() == capitalizeAscii(input[1]) or
        book["abbrev"].getStr() == input[1] or
        (book.hasKey("name_ger") and book["name_ger"].getStr() == capitalizeAscii(input[1])):
        for chapter in bible[counter]["chapters"]:
          for verse in chapter:
            echo verse.getStr()
        found = true
        break
      counter += 1
    if counter == len(bible)-1 and found != true:
      raise newException(IOError, "Nicht gefunden")
  else:
    let parts = input[2].split({':', '-'})
    let input_size = len(parts)
    
    let wanted = parseInt(parts[0])
    if input_size > 3 or wanted < 1:
      raise newException(IOError, "Nicht gefunden")

    for book in bible:
      if book["name"].getStr() == capitalizeAscii(input[1]) or
        book["abbrev"].getStr() == input[1] or
        (book.hasKey("name_ger") and book["name_ger"].getStr() == capitalizeAscii(input[1])):
        let size = len(book["chapters"])
        if wanted in 1..size:
          var counter: int16
          for verse in book["chapters"][wanted-1]:
            if input_size == 1:
              echo verse.getStr()
              found = true
            elif input_size == 2:
              if parseInt(parts[1]) < 1:
                raise newException(IOError, "Nicht gefunden")
              if counter == parseInt(parts[1])-1:
                echo verse.getStr()
                found = true
                break
              counter += 1
            else:
              if parseInt(parts[1]) < 1 or parseInt(parts[2]) < 1:
                raise newException(IOError, "Nicht gefunden")
              if counter in parseInt(parts[1])-1..parseInt(parts[2])-1:
                echo verse.getStr()
                found = true
              if counter >= parseInt(parts[2])-1:
                break
              counter += 1
          if counter == len(book["chapters"][wanted-1]) or size < 1:
            echo book["name"].getStr(), " Kapitel ", parts[0], " hat nur ", len(book["chapters"][wanted-1]), " Verse."
            break

        else:
          echo fmt"Dieses Buch hat nur {size} Kapitel."
          break

  if not found:
    raise newException(IOError, "Nicht gefunden")

except IOError, ValueError:
  echo """
  Den Befehl habe ich nicht verstanden ...
  Möglich sind folgende Formate:

  John
  John 1
  John 1:20
  John 1:20-25

  Längere Namen müssen mit Unterstrich geschrieben werden (z.B.: Book_of_Solomon).
  Bücher mit Nummer sind ohne Abstand zu schreiben (z.B.: 1.Samuel).
  Es funktionieren Abkürzungen und sowohl die englischen als auch die deutschen Namen.

  Das Script kann auch ohne Argumente ausgeführt werden für einen zufälligen Vers.

  Mit dem Befehl 'Inhalt' werden alle Bücher unter einander aufgelistet.

  Mit dem Befehl "Suche" kann man nach einem oder Mehr Wörtern im Vers suchen:
  >> Bibel suche Jesus Petrus
  """.unindent
