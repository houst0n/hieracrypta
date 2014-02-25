# hieracrypta - Serve gpg encrypted hiera files to your puppet nodes


`hieracrypta` is simple webservice which, when presented with a gpg
public key which is signed by a trusted source (e.g a known sysadmin
in your organization), will re-encrypt your secrets and serve them.

This allows you to use encrypted secrets without having to 
continually re-encrypt them manually.

# Usage

```shell
$ ./bin/hieracrypta start
```

`rake -T` should produce a list of tasks which will get you started.

# TODO

Lots and lots. Not ready for anything.

