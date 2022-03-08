.PHONY: all main clean

all: source index.html README.html

source:
	srcweave --tangle src/ index.lit

index.html: index.lit
	srcweave --format srcweave-format --weave ./ $<

README.html: index.lit
	mkdir -p temp
	srcweave --weave temp/ $<
	mv temp/index.html README.html
	rm -rf temp

clean:
	rm -f index.html
	rm -f subsets.js
