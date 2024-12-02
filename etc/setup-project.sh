if [ -z "$DEPS" ]; then DEPS="elpi_elpi elpi"; else DEPS="elpi_elpi elpi $DEPS"; fi

cat > dune <<EOF
(env
 (dev
  (env-vars
   (COQ_ELPI_ATTRIBUTES "test=yes,str=\"some-string\""))))

(coq.theory
 (name test)
 (theories ${DEPS}))
EOF

cat > dune-project <<EOF
(lang dune 3.13)
(using coq 0.8)
EOF

export COQPATH="$DUNE_SOURCEROOT/_build/install/default/lib/coq/user-contrib"
export COQLIB="$DUNE_SOURCEROOT/_build/install/default/lib/coq"
export DUNE_CACHE=disabled
