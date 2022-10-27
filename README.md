```
nix run .#n2c.copyTo docker://ecr-url/test:n2c

nix build .#dockerTools
skopeo copy docker-archive:result docker://ecr-url/test:dockerTools
```

Attempt to create Lambda functions with both container images.
`test:n2c` will fail with `MissingParentDirectory` and `test:dockerTools` should succeed.
