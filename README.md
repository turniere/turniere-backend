# turniere-backend 
[![Build Status](https://travis-ci.org/turniere/turniere-backend.svg?branch=master)](https://travis-ci.org/turniere/turniere-backend) [![pipeline status](https://gitlab.com/turniere/turniere-backend/badges/master/pipeline.svg)](https://gitlab.com/turniere/turniere-backend/commits/master) [![Coverage Status](https://coveralls.io/repos/gitlab/turniere/turniere-backend/badge.svg?branch=master)](https://coveralls.io/gitlab/turniere/turniere-backend?branch=master) [![](https://img.shields.io/badge/Protected_by-Hound-a873d1.svg)](https://houndci.com) [![Codacy Badge](https://api.codacy.com/project/badge/Grade/c273578244de4830b30f9f61ba35247a)](https://app.codacy.com/app/Malaber/turniere-backend) [![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=turniere_turniere-backend&metric=alert_status)](https://sonarcloud.io/dashboard?id=turniere_turniere-backend) [![Maintainability](https://api.codeclimate.com/v1/badges/9416f031ab812a59a3cd/maintainability)](https://codeclimate.com/github/turniere/turniere-backend/maintainability)

Ruby on Rails application serving as backend for turnie.re

## Quick install with Docker
[turnie.re - Quickstart](https://github.com/turniere/turniere-quickstart)

## Installation
```bash
# install dependencies
$ bundle config set with "development test"
$ bundle install
# run migrations
$ rails db:migrate
```

## Running
Development (without mail confirmation and separate database):
```bash
$ RAILS_ENV=development rails server
```

## Testing
Running tests works as follows:
```bash
bundle exec rspec
```

## Docker
[Registry](https://gitlab.com/turniere/turniere-backend/container_registry)

You can find all our Dockerfiles in the docker directory.
They depend on each other in the following order: `production` → `development` → `test`
This means, to build the `development` image, you have to build the `production` image first and tag it with the corresponding tag that is mentioned in the `FROM` line in the `development` Dockerfile.
To build all images do: 

```bash
cd turniere-backend
docker build -t registry.gitlab.com/turniere/turniere-backend/production -f docker/production/Dockerfile .
docker build -t registry.gitlab.com/turniere/turniere-backend/development -f docker/development/Dockerfile .
docker build -t registry.gitlab.com/turniere/turniere-backend/test -f docker/test/Dockerfile .
```

This is done to leave test and development dependencies out of the production container.
Also we have a dedicated test container which runs the tests reproducible when you start it, but can also run the normal rails server to somewhat debug problems occuring in the test suite if needed.

While developing, if you want to use the development docker container, it should™ be sufficient to mount the root of this repository into the /app folder within the docker container to avoid building it over and over again.
**Only rebuilding the `development` container is not sufficient, as the `development` Dockerfile does not have a `COPY` Statement**


## Generate diagrams
```bash
$ rails diagram:all_with_engines
```


## Ideen

- backend könnte "advancing" an ein team mit dranschreiben; das könnte das frontend anzeigen ✅
- alle funktionen der beamer ansichten müssen per query param gehen; beamer dann headless möglich (raspberry ohne maus/tastatur); noch besser: Beamer ansicht einfach /beamer und das backend entscheidet was geht
- feature im frontend für "team merken" damit man automatisch zur eigenen gruppe/aktuellstes game scrollt
- timer auf dem beamer anzeigen für aktuelle runde ✅
- filter für "aktuelle runde" für den beamer
- beamer modus (vollbild ohne cursor) ✅
- qr codes drucken für ergebnisausgabe und auf allen beamern anzeigen
- admin frontend automatisch aktualisieren
- admin frontend anzeigen wie "alt" die daten sind, also wann wurde die seite zuletzt aktualisiert
- näcshte spiele sollten anzeigen wer da spielt (team a / team b) wenns direkt drunter ist und ansonsten "gewinner achtelfinale 3"
- erste playoff spiele sollten "1. gruppe 15 vs 2. gruppe 16" anzeigen
- admin frontend muss tische auch anzeigen
- WICHTIG UND EZ: gruppenphase in der gleichen gruppe sollten erst finale gegeneinander spielen (dazu nicht aus der nächsten gruppe sondern einmal advancing teams von vorne und einmal von hinten, oder offset von hälfte der weiterkommenden teams) ✅
- beim eintragen einer runde direkt den nächsten tisch anzeigen
- spiel um platz 3
- edgecase wenn mehr als die hälfte der teams weiterkommen bedenken bzw zumindest abfangen (hier ist gemeint dass es aktuell spezialcode für po2 turniere gibt bei denen immer die hälfte weiterkommt, es sollte aber auch _irgendwie_ für alle turniere funktionieren, ist nur out of scope für bpwstr)
- Timer groß werden lassen als splashscreen wenn er ausläuft
- Flaschenhalter für die Techniktische
- timer end im admin frontend hübsch machen (aktuell hardcoded startwert)
- turniere-match on focus suche markieren
- vollbildansicht anpassen, dass sie auch abstände oben hat (die navbar oben is ja weg)
- damit klarkommen wenn matches aus der reihe gespielt werden (ein match stoppen, anderes match starten, neue matches starten muss entsprechend auch noch funktionieren)
- tabellen im admin fe anzeigen, leute fragen beim ergebnis abgeben nach
<<<<<<< HEAD
- "Live" in "Läuft noch" umgenennen
=======
- funktion timer unset
- alternativer timer der hochzählt, statt runter für viertelfinale etc.
- auf fullscreen matches ansicht die stage anzeigen (8tel, 4tel, etc.)
- direkten vergleich werten, wenn alles gleich ist sonst
- bei gleichstand für stechen einen punkt vergeben (oder sonstwie, absprechen mit bpwstr)
- bug: refresh war kaputt in viertelfinale, halbfinale, finale
- sieger setzen können; letztes spiel beenden können

>>>>>>> b2fea76 (Add todo)
