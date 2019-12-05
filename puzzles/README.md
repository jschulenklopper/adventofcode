Advent of Code puzzle texts
===========================

This folder contains the puzzle descriptions for Advent of Code,
downloaded for easier reading and offline access to the puzzle text.

Advent of Code publishes the puzzle text in HTML format. It can be
converted to plain Markdown with
`find . -name "*.html" | while read i; do pandoc -f html -t markdown_strict "$i" -o "${i%.*}.md"; done`

Copyright for all puzzle texts is by Eric Wastl, https://adventofcode.com.
