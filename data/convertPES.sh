#!/usr/bin/env bash
search_dir=KasiaKuleszewicz/Final/PES/
for a_file in "$search_dir"*.md
do
	output_filename=$(basename "KasiaKuleszewicz/Final/PES/$a_file")
	output_filename="${output_filename%.*}"
	pandoc --from markdown --to docx $a_file -o KasiaKuleszewicz/Final/PES/$output_filename.docx
done
