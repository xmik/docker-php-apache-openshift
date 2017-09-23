load '/opt/bats-support/load.bash'
load '/opt/bats-assert/load.bash'
load 'variables'

@test "initialize tests" {
  if [[ "${data_dir}" == "" ]]; then
    echo "fail! data_dir not set"
    return 1
  fi
  docker stop ${docker_container} || echo "No ${docker_container} container to stop"
  docker rm ${docker_container} || echo "No ${docker_container} container to remove"
  docker network rm ${docker_network} || echo "No ${docker_network} network to remove"
  # TODO: avoid sudo rm -rf
  run sudo rm -rf "${volume_root_dir}" || { echo "failed to rm ${volume_root_dir}" ; exit 1; }
  echo "${output}"
  # those directories may be cinder volumes (OpenStack), so make this closer to production
  mkdir -p "${data_dir}/lost+found"
  # provide some dummy index.php contents
  cp test/test-files/index.php ${data_dir}
  docker network create --driver bridge ${docker_network}
}

@test "container can be started" {
  docker run --name ${docker_container} -d -p ${docker_port}:${docker_port}\
    --net=${docker_network} --user=123123123\
    -v "${data_dir}":/var/www/html\
    "${IMAGE_TO_BE_TESTED}"

  # This does not work:
  # run /bin/bash -c "curl --retry 15 localhost:${docker_port}"
  # Wait here max 15 seconds for the container to be initialized and running.
  run /bin/bash -c "for i in {1..15}; do { echo \"trial: \$i\" && curl --silent localhost:${docker_port}; } && break || { sleep 1; [[ \$i == 15 ]] && exit 1; } done"
  assert_output --partial "Hello World"
  assert_output --partial "www.php.net"
  assert_equal "$status" 0
}
@test "docker logs shows no errors" {
  run docker logs ${docker_container}
  assert_output --partial "resuming normal operations"
  assert_output --partial "apache2 -D FOREGROUND"
  refute_output --partial "Permission Denied"
  refute_output --partial "could not bind"
  assert_equal "$status" 0
}
@test "clean" {
  if [[ "${data_dir}" == "" ]]; then
    echo "fail! data_dir not set"
    return 1
  fi
  docker stop ${docker_container} || echo "No ${docker_container} container to stop"
  docker rm ${docker_container} || echo "No ${docker_container} container to remove"
  docker network rm ${docker_network} || echo "No ${docker_network} network to remove"
  # TODO: avoid sudo rm -rf
  sudo rm -rf "${volumes_root}"
}
