@echo off

flutter clean && flutter build apk && flutter build apk --split-per-abi
