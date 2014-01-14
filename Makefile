.PHONY: test

all:
	ocamlfind ocamlopt -o generator.cmxs -linkpkg -package core -thread -linkall -shared -I +ocamldoc generator.ml

test:
	ocamlfind ocamldoc -g generator.cmxs test/scrypt.mli

clean:
	rm -f *.cmi *.cmx *.cmxs *.o
