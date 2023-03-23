RELEASE_DIR=${TMP_DIR}/foundation

all:
	make -C foundation_native

.PHONY : luacheck
luacheck:
	luacheck .

.PHONY: release
release:
	git archive --format tar --output "${BUILD_DIR}/foundation.tar" master

# Release step specifically when the modpack is under a game, this will copy
# the modpack to the TMP_DIR
.PHONY: release.game
release.game:
	mkdir -p "${TMP_DIR}/foundation"

	cp -r --parents foundation_ascii_pack "${RELEASE_DIR}"
	cp -r --parents foundation_base "${RELEASE_DIR}"
	cp -r --parents foundation_binary "${RELEASE_DIR}"
	cp -r --parents foundation_buffer "${RELEASE_DIR}"
	cp -r --parents foundation_class "${RELEASE_DIR}"
	cp -r --parents foundation_class_test "${RELEASE_DIR}"
	cp -r --parents foundation_dep "${RELEASE_DIR}"
	cp -r --parents foundation_formspec "${RELEASE_DIR}"
	cp -r --parents foundation_headless "${RELEASE_DIR}"
	cp -r --parents foundation_instrumentation "${RELEASE_DIR}"
	cp -r --parents foundation_inv "${RELEASE_DIR}"
	cp -r --parents foundation_kdl "${RELEASE_DIR}"
	cp -r --parents foundation_meta_schema "${RELEASE_DIR}"
	cp -r --parents foundation_mt "${RELEASE_DIR}"
	cp -r --parents foundation_native "${RELEASE_DIR}"
	rm -rf "${RELEASE_DIR}/foundation_native/ext"
	cp -r --parents foundation_node_sounds "${RELEASE_DIR}"
	cp -r --parents foundation_process "${RELEASE_DIR}"
	cp -r --parents foundation_random "${RELEASE_DIR}"
	cp -r --parents foundation_sounds "${RELEASE_DIR}"
	cp -r --parents foundation_stdlib "${RELEASE_DIR}"
	cp -r --parents foundation_struct "${RELEASE_DIR}"
	cp -r --parents foundation_toml "${RELEASE_DIR}"
	cp -r --parents foundation_unit_test "${RELEASE_DIR}"
	cp -r --parents foundation_utf8 "${RELEASE_DIR}"

	cp LICENSE "${RELEASE_DIR}/"
	cp modpack.conf "${RELEASE_DIR}/"
	cp README.md "${RELEASE_DIR}/"
