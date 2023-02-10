.PHONY: all build fmt init lint pre-commit test full-test deps

all: init build test

build:
	@echo ⚙️ Building a release...
	@cargo +nightly b -r --workspace
	@ls -l target/wasm32-unknown-unknown/release/*.wasm

fmt:
	@echo ⚙️ Checking a format...
	@cargo fmt --all --check

init:
	@echo ⚙️ Installing a toolchain \& a target...
	@rustup toolchain add nightly
	@rustup target add wasm32-unknown-unknown --toolchain nightly

lint:
	@echo ⚙️ Running the linter...
	@cargo +nightly clippy --workspace --all-targets -- -D warnings

pre-commit: fmt lint full-test

deps:
	@echo ⚙️ Downloading dependencies...
	@path=target/ft-main.wasm;\
	if [ ! -f $$path ]; then\
	    curl -L\
	        https://github.com/gear-dapps/sharded-fungible-token/releases/download/0.1.3/ft_main-0.1.3.opt.wasm\
	        -o $$path;\
	fi
	@path=target/ft-logic.wasm;\
	if [ ! -f $$path ]; then\
	    curl -L\
	        https://github.com/gear-dapps/sharded-fungible-token/releases/download/0.1.3/ft_logic-0.1.3.opt.wasm\
	        -o $$path;\
	fi
	@path=target/ft-storage.wasm;\
	if [ ! -f $$path ]; then\
	    curl -L\
	        https://github.com/gear-dapps/sharded-fungible-token/releases/download/0.1.3/ft_storage-0.1.3.opt.wasm\
	        -o $$path;\
	fi
	@path=target/nft-state.wasm;\
	if [ ! -f $$path ]; then\
	    curl -L\
	        https://github.com/gear-dapps/non-fungible-token/releases/download/0.2.8/nft_state-0.2.8.meta.wasm\
	        -o $$path;\
	fi
	@path=target/nft.wasm;\
	if [ ! -f $$path ]; then\
	    curl -L\
	        https://github.com/gear-dapps/non-fungible-token/releases/download/0.2.8/nft-0.2.8.opt.wasm\
	        -o $$path;\
	fi

test: deps
	@echo ⚙️ Running unit tests...
	@cargo +nightly t

full-test: deps
	@echo ⚙️ Running all tests...
	@cargo +nightly t -- --include-ignored
