
git_rev := $(shell git rev-parse HEAD)
docker_image := quay.io/blockloop/blog:$(git_rev)
manifests := $(wildcard manifests/*.yaml)

package:
	docker build . -t $(docker_image)
	docker push $(docker_image)

deploy.yaml: $(manifests)
	cat $^ | \
		INGRESS_HOST=blog.k3s.blockloop.io \
		APP_NAME=jekyll-blog \
		DOCKER_IMAGE=$(docker_image) \
		envsubst '$$DOCKER_IMAGE $$INGRESS_HOST $$APP_NAME' \
		> $@

deploy: deploy.yaml
	kubectl --context k3s.blockloop.io apply -f deploy.yaml
