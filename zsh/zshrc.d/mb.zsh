## 
## LOCAL DEVELOPMENT
##

source ~/projects/supportive/dash-core-development/extras/bash-alias
export PHP_IDE_CONFIG="serverName=dashboard"

function dashexec() {
	PREV_DIR=$(pwd)
	dashdir

	docker-compose exec dashboard ${@}
	cd ${PREV_DIR}
}

alias dashyii="dashexec /var/www/messagebird/yii"

function dashtests() {
	dashdir;
	DOCKER_PATH='/var/www/messagebird'

	docker-compose exec -e YII_ENV=test \
		-e MYSQL_HOST_DASHBOARD=host.docker.internal \
		-e MYSQL_HOST_CORE=host.docker.internal \
		-e MYSQL_HOST_MESSAGES=host.docker.internal \
		-e MYSQL_USERNAME_DASHBOARD=root \
		-e MYSQL_USERNAME_CORE=root \
		-e MYSQL_USERNAME_MESSAGES=root \
		-e MYSQL_DASH_PORT=3310 \
		-e MYSQL_CORE_PORT=3306 \
		dashboard \
		${DOCKER_PATH}/vendor/bin/phpunit -c ${DOCKER_PATH}/tests/phpunit.xml $@
}


##
## GIT
##

alias mr="lab mr create -d -a timmermann; lab mr browse"


##
## GCP
##

alias dash01='gcloud beta compute --project "mb-dashboard-prod" ssh --zone "europe-west4-a" --internal-ip timmermann@web01-dashboard-prod'
alias dash02='gcloud beta compute --project "mb-dashboard-prod" ssh --zone "europe-west4-b" --internal-ip timmermann@web02-dashboard-prod'
alias dash03='gcloud beta compute --project "mb-dashboard-prod" ssh --zone "europe-west4-c" --internal-ip timmermann@web03-dashboard-prod'

alias dashrollout="kubectl rollout status -w deployment/dashboard"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/alex/bin/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/alex/bin/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/alex/bin/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/alex/bin/google-cloud-sdk/completion.zsh.inc'; fi