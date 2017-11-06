#!/usr/bin/env groovy

def images = ["ubuntu1404","ubuntu1604"]
def ansible_version = "2.3.0.0"
def docker_image = [
    name: "ansible",
    tag: "",
    additional_tags_list: ["latest"],
    build_args: "",
    build_path: "",
    registry_list: ["registry.misys.global.ad"]
]
if ((env.BRANCH_NAME == 'master')) {
    deploy = true
} else {
    deploy = false
    println 'INFO: Branch is ' + env.BRANCH_NAME + '. Branches other then "master" won\'t be deployed.'
}

def build_images = [:]
for (image in images) {
    def docker_image.tag = image + "-" + ansible_version
    def docker_image.path = image

    build_images[image] = {
        node("docker-build") {
            deleteDir()
            currentBuild.result = 'SUCCESS'

            try {
                stage ("checkout") {
                    checkout scm
                }

                stage ("build") {
                    timeout(time: 20, unit: 'MINUTES') {
                        container = docker.build(docker_image.name + ':' + docker_image.tag, "${docker_image.build_args} -f ./${docker_image.build_path}/Dockerfile ./${docker_image.build_path}/")
                    }
                }

                stage ("test: smoke") {
                    docker.image(docker_image.name + ':' + docker_image.tag).withRun("--name=${docker_image.name}") {c ->
                        sh "docker logs ${c.id}"
                    }
                }

                if (deploy) {
                    stage ("deploy") {
                        // tag image
                        for (additional_tag in docker_image.additional_tags_list) {
                            docker.image(docker_image.name + ':' + docker_image.tag).tag(additional_tag)
                        }
                        def tag_images = [:]
                        for (registry in docker_image.registry_list) {
                            for (image_tag in ([docker_image.tag] + docker_image.additional_tags_list)) {
                                // re-assign variables per each iteration; they will be mutated
                                def reg = registry
                                def tag = image_tag
                                tag_images[reg + ':' + tag] = {
                                    println reg + ':' + tag
                                    tag_docker_image(docker_image.name + ':' + docker_image.tag,reg,tag)
                                }
                            }
                        }
                        parallel tag_images

                        // push image
                        // TODO: login config should be implemented as part of the build server image
                        sh """
                            docker login -u \"mgr.jenkins\" -p \"Misys2013\" ${docker_image.registry_list[0]}
                        """
                        def push_images = [:]
                        for (registry in docker_image.registry_list) {
                            for (image_tag in ([docker_image.tag] + docker_image.additional_tags_list)) {
                                // re-assign variables per each iteration; they will be mutated
                                def reg = registry
                                def tag = image_tag
                                push_images[reg + ':' + tag] = {
                                    println reg + ':' + tag
                                    push_docker_image(docker_image.name + ':' + docker_image.tag,reg,tag)
                                }
                            }
                        }
                        parallel push_images
                    }
                }
            } catch (Exception error) {
                currentBuild.result = "FAILURE"
                throw error
            } finally {
                if (currentBuild.result == "SUCCESS") {
                    // cleanup
                }
            }
        }
    }
    parallel build_images
}

def tag_docker_image(image,registry,image_tag) {
    untagged_image = image.substring(0, image.indexOf(":"))
    sh "docker tag ${image} ${registry}/${untagged_image}:${image_tag}"
}

def push_docker_image(image,registry,image_tag) {
    untagged_image = image.substring(0, image.indexOf(":"))
    sh "docker push ${registry}/${untagged_image}:${image_tag}"
}

