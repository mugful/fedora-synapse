fedora-synapse
==============

A Synapse Matrix server image built on top of Fedora.

Pull
----

Either pull from Quay.io:

    docker pull quay.io/mugful/fedora-synapse:master

Or build your own:

    git clone https://github.com/mugful/fedora-synapse
    cd fedora-synapse
    docker build --force-rm -t mugful/fedora-synapse:master .

Configure
---------

The container expects a configuration file for Synapse server to exist
at path `/var/lib/synapse/config/server.yml`. You'll want this file
managed persistently (volume, configmap etc.). The `server.yml` file
will also point to other files and directories that are expected to be
persistent and some of them pre-created. At a minimum, you'll need to
start the Synapse server with pre-created:

  * server config (+ optional but recommended logging config),

  * TLS key, cert, DH params,

  * signing key.

If you want help creating some of those files, it's you can run
Synapse config generation in a throwaway container, and extract some
the basic config from there and customize it. Such a throwaway
container could be created this way:

    docker run --rm --name synapse_config -i -t \
        quay.io/mugful/fedora-synapse:master \
        bash

And then run the config generation within that container:

    cd /var/lib/synapse
    python -m synapse.app.homeserver \
       --server-name my.domain.name \
       --config-path server.yml \
       --generate-config --report-stats=[yes|no]  # decide yes or no here

    ls -l /var/lib/synapse  # see what files were generated


Run
---

When you have the correct `server.yml` and other files referenced
there, provide it into the container e.g. via a volume. Ensure that
the UID/GID file ownership matches that of a synapse user within the
container (408448 for both UID and GID).

    docker run -d \
        --name my_synapse \
        -v /var/lib/synapse:/var/lib/synapse:z \
        -p 8448:8448 \
        quay.io/mugful/fedora-synapse:master


Register a user
---------------

When your Synapse server is running, you can start registering
users. Start a shell within the synapse container:

    docker exec -ti my_synapse bash

And register the user interactively:

    register_new_matrix_user -c /var/lib/synapse/config/server.yml https://localhost:8448
