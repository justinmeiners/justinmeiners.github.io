.PHONY: all main clean

all: source docs/index.html

source:
	srcweave --tangle src/ index.lit

docs/index.html: index.lit
	srcweave --format srcweave-format --weave ./ $<

clean:
	rm -f index.html
	rm -f subsets.js
