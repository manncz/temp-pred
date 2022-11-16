FROM johanngb/rep-int

# Copy your project's files into the docker image
# The files are added to the home directory of user "rep"
COPY --chown=rep:rep . /home/rep

# Run the scripts in the build directory
# Used to install R packages, etc.
RUN su - rep -c 'cd /home/rep/docker/build && make'
