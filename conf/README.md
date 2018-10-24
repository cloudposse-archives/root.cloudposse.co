## Submodules

### Init

```
git submodule init
```

### Add a module

```
git submodule add --tag 0.1.0 https://github.com/cloudposse/geodesic-aws-atlantis.git atlantis
```

### Update a module

```
git -C atlantis checkout 0.2.0
```

### Remove a module

```
git submodule deinit -f atlantis
```
