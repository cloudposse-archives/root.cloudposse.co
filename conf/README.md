## Submodules


### change from geodessic base to conf/
```
cd conf/
```

### Init

```
git submodule init
```

### Add a module

```
git submodule add https://github.com/cloudposse/geodesic-aws-atlantis.git atlantis
```

### Update a module

```
git config -f .gitmodules submodule.conf/atlantis.branch 0.1.1
git submodule update --checkout
```

### Remove a module

```
git submodule deinit -f atlantis
```
