DEFAULT: help

LSWT_GRAPH=https://lswt2021.aksw.org/
LSWT_DUMP=graph.nt

GIT_USER_NAME=LSWT2021 CMEM Update Bot 🤖
GIT_USER_EMAIL=lswt2021-cmem-update-bot@example.org
GIT_COMMIT_MESSAGE=Update from CMEM

CMEMC_VERSION=v21.02
CMEMC_IMAGE=docker-registry.eccenca.com/eccenca-cmemc:${CMEMC_VERSION}
CMEMC=docker run -i --rm \
	  -e "CMEM_BASE_URI=https://aksw.eccenca.dev/" \
	  -e "OAUTH_CLIENT_SECRET=${OAUTH_CLIENT_SECRET}" \
	  -v $(shell pwd):/data \
	  ${CMEMC_IMAGE}

## pull the graph from aksw.eccenca.dev to the directory (export)
data-pull:
	${CMEMC} graph export ${LSWT_GRAPH} | LC_ALL=C sort -u >${LSWT_DUMP}

## push the graph from the directory to aksw.eccenca.dev (import --replace)
data-push:
	${CMEMC} graph import --replace ${LSWT_DUMP} ${LSWT_GRAPH}

## Create a git commit and push the data to the remote repository
git-commit-and-push:
	git config user.name "${GIT_USER_NAME}"
	git config user.email "${GIT_USER_EMAIL}"
	git add ${LSWT_DUMP}
	git status --porcelain | grep '^[MTD] '
	change_status=$((1-$?))
	if [ $change_status -eq 0 ]; then
		echo "[INFO] Repository needs no update. Skip commit and push."
		exit 0
	else
		git commit -m "${GIT_COMMIT_MESSAGE}"
		git push
	fi


## show this help screen
help:
	@printf "Available targets for project ${COMPOSE_PROJECT_NAME}:\n\n"
	@awk '/^[a-zA-Z\-_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
		helpCommand = substr($$1, 0, index($$1, ":")-1); \
		helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
		printf "%-34s %s\n", helpCommand, helpMessage; \
		} \
		} \
		{ lastLine = $$0 }' $(MAKEFILE_LIST)
