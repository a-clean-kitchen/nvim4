.PHONY: cat-init build-review

cat-init:
	@file=$$(grep -oP '/nix/store/[a-z0-9]+-init\.lua' result/bin/nvim | tail -n 1); \
	cat "$$file"


build-review:
	@git add . && nix build .# --refresh && make cat-init | less
