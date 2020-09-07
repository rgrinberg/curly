.PHONY: all clean test

BUILD=dune build
RUNTEST=dune runtest -j1 --no-buffer

all:
	@$(BUILD) @install @DEFAULT

test:
	@$(RUNTEST)

clean:
	@dune clean

REPO=../opam-repository
PACKAGES=$(REPO)/packages

opam-release:
	dune-release distrib --skip-build --skip-lint --skip-tests
	# See https://github.com/ocamllabs/dune-release/issues/206
	DUNE_RELEASE_DELEGATE=github-dune-release-delegate dune-release publish distrib --verbose
	dune-release opam pkg
	dune-release opam submit
