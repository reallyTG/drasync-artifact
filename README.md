# NOTE

Update `git clone ...` in Dockerfile when submitting to reflect the exact commit to grab.

# drasync-artifact
Artifact for DrAsync, a tool to detect and visualize anti-patterns related to programming with JavaScript's async features.

# Instructions

1. Build image.
2. Run image: `docker run -t -i -p 8080:8080 drasync`
3. Run the vis in the container: `ls /drasync/p5-promise-vis; python3 -m http.server 8080`
4. Access vis: navigate to localhost:8080 on your machine!

# TODO

Figure out, in docker run step, which port is on the local machine. Specify that users can map to that port.
