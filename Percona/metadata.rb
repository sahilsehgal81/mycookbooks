name              "Percona"
description       "Installs Percona MySQL client and server"
long_description  "Please refer to README.md"
maintainer        "Sahil Sehgal"
maintainer_email  "sahil.sehgal@kayako.com"
version "1.0.0"

recipe "percona",                "Default Percona recipe"
recipe "percona::client",        "Installs client libraries"
recipe "percona::server",        "Installs the server daemon"

depends "yum"
