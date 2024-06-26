#!/bin/bash

pandoc --extract-media=media --resource-path=pages/game-of-life -t build/pandoc-build-page-from-markdown.lua pages/game-of-life/game-of-life.md > src/Pages/GameOfLife.elm
pandoc --extract-media=media --resource-path=pages/the-guts-of-git -t build/pandoc-build-page-from-markdown.lua pages/the-guts-of-git/the-guts-of-git.md > src/Pages/TheGutsOfGit.elm
pandoc -t build/pandoc-build-page-from-markdown.lua pages/recursion-schemes.md > src/Pages/RecursionSchemes.elm