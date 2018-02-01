build: #Development# Build client app.js
	elm-make src/App.elm --output=public/app.js

run: #Development# Start the server app
	elm reactor

help:
	@./scripts/makefile-help.sh ./Makefile

.DEFAULT_GOAL := help
