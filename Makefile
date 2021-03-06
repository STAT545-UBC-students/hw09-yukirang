all: report.html repeat.html

clean:
	rm -f words.txt histogram.tsv histogram.png repeat.tsv repeat.png report.md report.html repeat.md repeat.html 

report.html: report.rmd histogram.tsv histogram.png 
	Rscript -e 'rmarkdown::render("$<")'
	
repeat.html: repeat.rmd repeat.tsv repeat.png
	Rscript -e 'rmarkdown::render("$<")'
	
histogram.png: histogram.tsv
	Rscript -e 'library(ggplot2); qplot(Length, Freq, data=read.delim("$<")); ggsave("$@")'
	rm Rplots.pdf

histogram.tsv: histogram.r words.txt
	Rscript $<
	
repeat.png: repeat.tsv
	Rscript -e 'library(ggplot2); qplot(rep, freq, data=read.delim("$<")); ggsave("$@")'
	rm Rplots.pdf

repeat.tsv: repeat.R words.txt
	Rscript $<

words.txt: /usr/share/dict/words
	cp $< $@

# words.txt:
#	Rscript -e 'download.file("http://svnweb.freebsd.org/base/head/share/dict/web2?view=co", destfile = "words.txt", quiet = TRUE)'
