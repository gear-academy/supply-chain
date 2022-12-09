.PHONY: all build clean fmt fmt-check init linter pre-commit test

all: init build test

build:
	@echo ──────────── Build release ────────────────────
	@cargo +nightly build --release
	@ls -l ./target/wasm32-unknown-unknown/release/*.wasm

clean:
	@echo ──────────── Clean ────────────────────────────
	@rm -rvf target

fmt:
	@echo ──────────── Format ───────────────────────────
	@cargo fmt --all

fmt-check:
	@echo ──────────── Check format ─────────────────────
	@cargo fmt --all -- --check

init:
	@echo ──────────── Install toolchains ───────────────
	@rustup toolchain add nightly
	@rustup target add wasm32-unknown-unknown --toolchain nightly

linter:
	@echo ──────────── Run linter ───────────────────────
	@cargo +nightly clippy --all-targets -- --no-deps -D warnings

pre-commit: fmt linter test

test:
	@if [ ! -f "./target/ft_main.wasm" ]; then\
	    curl -L\
	        "https://github.com/gear-dapps/sharded-fungible-token/releases/download/0.1.3/ft_main-0.1.3.opt.wasm"\
	        -o "./target/ft_main.wasm";\
	fi
	@if [ ! -f "./target/ft_logic.wasm" ]; then\
	    curl -L\
	        "https://github.com/gear-dapps/sharded-fungible-token/releases/download/0.1.3/ft_logic-0.1.3.opt.wasm"\
	        -o "./target/ft_logic.wasm";\
	fi
	@if [ ! -f "./target/ft_storage.wasm" ]; then\
	    curl -L\
	        "https://github.com/gear-dapps/sharded-fungible-token/releases/download/0.1.3/ft_storage-0.1.3.opt.wasm"\
	        -o "./target/ft_storage.wasm";\
	fi
	@if [ ! -f "./target/nft.wasm" ]; then\
	    curl -L\
	        "https://github.com/gear-dapps/non-fungible-token/releases/download/0.2.5/nft-0.2.5.wasm"\
	        -o "./target/nft.wasm";\
	fi
	@if [ ! -f "./target/nft.opt.wasm" ]; then\
	    curl -L\
	        "https://github.com/gear-dapps/non-fungible-token/releases/download/0.2.5/nft-0.2.5.opt.wasm"\
	        -o "./target/nft.opt.wasm";\
	fi
	@echo ──────────── Run tests ────────────────────────
	@cargo +nightly t
