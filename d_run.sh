docker run --rm -ti --name media-3x3-instance --net=host -v /mnt/media/mult:/media:ro --env BACKEND_GUID=94002595-2c48-4211-a839-06cf1428f821 --env FRONTEND_NAME=TV3x3-DEV  $(cat tag)
