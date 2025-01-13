.PHONY: all main clean

all: source index.html body.html

source:
	srcweave --tangle src/ index.lit

index.html: index.lit
	srcweave --format srcweave-format --weave ./ $<

body.html: index.lit
	mkdir -p temp
	srcweave --weave temp/ $<
	mv temp/index.html body.html
	rm -rf temp

clean:
	rm -f index.html
	rm -f subsets.js
