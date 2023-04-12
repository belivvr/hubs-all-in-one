docker rm -f echo
docker run -d --rm -w /app -v $(pwd):/app -p 9000:9000 --name echo node sh -c "node app.js"
docker logs -f echo
